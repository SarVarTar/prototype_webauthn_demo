class UsersController < ApplicationController
  skip_before_action :verify_authenticity_token, :only => [:decode_webauthn_response]
  
  @@rp_domain = 'localhost'

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def edit
  end

  # create account using username and password
  def create
    @user = User.new(user_params)
    @user.email.downcase!
    if @user.save
      flash[:notice] = "Successful registration"
      redirect_to root_path
    else
      flash.now.alert ="unsuccessful registration"
      render :new
    end
  end

  def new_webauthn
    @user = User.new
  end

  # create account using webauthentication
  # acutally two parts:
  # 1 - generating and executing a javascript call to webauthentication API
  # 2 - javascript posts refined response data to the given response path
  #     the response is decoded and account gets created or error thrown
  # Part 1:
  def create_webauthn
    if(User.find_by(email: user_params[:email].downcase))
      puts 'USER EXISTS'
      flash[:alert] = 'Sorry already taken'
      redirect_to root_path
      return
    end
    # this is to be supplied by server
    rp_name = 'WebauthnPrototype'#your service name
    rp_domain = @@rp_domain#your Top Level Domain
    response_path = webauthn_decode_path

    # id, email and challenge need to be saved for later use
    challenge = PrototypeWebauthn::Helper.generate_challenge() #can be self generated, needs to be a base64 encoded string
    id = PrototypeWebauthn::Helper.generate_id() #can be self generated, needs to be a base64 encoded string
    session[:webauthn_id] = id
    session[:email] = user_params[:email].downcase
    session[:challenge] = challenge

    # generating and executing the javascript call with supllied values
    # this returns a javascript function call as string to be rendered by the client
    js_call = PrototypeWebauthn::Creation.generate_js_call(user_params[:email].downcase, rp_name, rp_domain, challenge, id, response_path)
    render js: js_call
  end
  # Part 2:
  def decode_webauthn_response
    rp_domain = @@rp_domain#your Top Level Domain
    origin = request.headers['origin'].nil? ? ('https://'+request.headers['Host']) : request.headers['origin'] #origin retrieval differs by browser. Chrome and Firefox are accounted for.
    response_data = PrototypeWebauthn::Creation.decode_response(params[:webauthn_response], session[:challenge], origin, rp_domain)
    if(response_data[:valid])
      puts 'DATA VALID'
        user = User.new
        user.email = session[:email].downcase
        user.webauthn_id = response_data[:credential_id]
        user.public_key = response_data[:public_key]
        user.password = 'default'
      if(user.save)
        puts 'SAVE SUCCESSFUL: ' + user.email
        session[:user_id] = user.id.to_s
        flash[:notice] = "Successful registration"
        redirect_to root_path
        return
      else
        puts 'FAILED TO SAVE USER'
      end
    else
      puts 'VALIDATIONS FAILED'
    end
    flash[:alert]= 'Not allowed or timed out'
    redirect_to new_webauthn_path
  end

end

private

def user_params
  params.
    require(:user).
    permit(:email, :password, :password_confirmation)
end
