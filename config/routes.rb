Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'users#new_webauthn'

  get '/login' => 'sessions#new'
  post '/login' => 'sessions#create'
  get 'new_webauthn_session', :to => 'sessions#new_webauthn'
  post 'new_webauthn_session', :to => 'sessions#create_webauthn'
  post 'webauthn_decode_authentication', :to => 'sessions#decode_webauthn_response'
  delete 'logout' => 'sessions#destroy'

  post 'test', :to => 'sessions#test'

  post '/users/:id', :to => 'users#show', :as => :user
  get 'new_webauthn', :to => 'users#new_webauthn'
  post 'new_webauthn', :to => 'users#create_webauthn'
  post 'login_webauthn', :to => 'users#login_webauthn'
  post 'webauthn_decode', :to => 'users#decode_webauthn_response'
  resources :users
end
