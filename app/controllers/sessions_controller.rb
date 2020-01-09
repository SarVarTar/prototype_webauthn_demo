class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token, :only => [:decode_webauthn_response]

  def new
  end

  def new_webauthn
    @user = User.new()
  end

  # authenticate using username and password
  def create
    user = User.find_by(email: params[:login][:email].downcase)
    if user && user.authenticate(params[:login][:password])
      session[:user_id] = user.id.to_s
      redirect_to root_path, notice: 'successfully logged in!'
    else
      flash.now.alert = 'incorrect email or password'
      render :new
    end
  end

  #authenticate using webauthentication
  def create_webauthn
    user = User.find_by(email: params[:user][:email].downcase)
    if(user.nil?)
      redirect_to root_path, notice: 'user not found'
      return
    end
    response_path = webauthn_decode_authentication_path
    challenge = PrototypeWebauthn::Helper.generate_challenge()
    js_call = PrototypeWebauthn::Authentication.generate_js_call(challenge, user.webauthn_id, response_path)
    session[:user_email] = params[:user][:email].downcase
    session[:challenge] = challenge
    render js: js_call
  end

  #decode the authenticators response and create session or not
  def decode_webauthn_response
    user = User.find_by(email: session[:user_email])
    origin = request.headers['origin'].nil? ? ('https://'+request.headers['Host']) : request.headers['origin']
    # needs the params of the javascript request, the stored session and public key.
    # returns true or false
    result = PrototypeWebauthn::Authentication.authenticate?(params[:webauthn_response], session[:challenge], origin, user.public_key)
    if(result)
      session[:user_id] = user.id.to_s
      redirect_to root_path, notice: 'successfully logged in!'
    else
      flash.alert = 'incorrect authenticator or timed out!'
      redirect_to :new_webauthn_session
    end
  end

  def test
    render js: 'webauthn_test();'
  end

  def destroy
    session.delete(:user_id)
    redirect_to login_path, notice: 'logged out!'
  end

end
