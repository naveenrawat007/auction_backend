Rails.application.routes.draw do
  # devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  require 'sidekiq/web'
  require 'sidekiq/cron/web'
  mount Sidekiq::Web => '/sidekiq'
  mount Apidoco::Engine, at: "/docs"
  namespace 'api' do
    namespace 'v1', constraints: ApiConstraint.new(version: 1) do
      devise_for :users, controllers:{ sessions: 'api/v1/users/sessions', registrations: 'api/v1/users/registrations' }
      get 'users/forgot_password', to: 'users#forgot_password'
      post 'users/password/new', to: 'users#new_password'
      get 'users/check_token', to: 'users#check'
      put 'users/resend_code', to: 'users#resend_verification_code'
      put 'users/verify', to: 'users#verify_code'
      get 'users/show', to: 'users#show'
      put "users/update_profile" => "users#update_profile"
      put "users/update_image" => 'users#update_image'
      get "admin/users", to: 'admins#users_list'

      get 'properties/new', to: 'properties#new'
      put 'properties/submit', to: 'properties#submit_for_review'
      get 'properties/:id', to: 'properties#show'
      get 'properties/:id/edit', to: 'properties#edit'
      post 'properties', to: 'properties#create'
      put 'properties', to: 'properties#update'
      get 'properties', to: 'properties#index'

      post 'register/properties/', to: 'properties#register'
      post 'properties/bids', to: 'bids#create'

      namespace 'admin' do
        get '/properties', to: 'properties#index'
        put 'properties/status', to: 'properties#update_status'
      end
    end
  end
end
