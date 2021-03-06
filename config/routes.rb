Rails.application.routes.draw do
  # devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  require 'sidekiq/web'
  require 'sidekiq/cron/web'
  mount Sidekiq::Web => '/sidekiq'
  mount Apidoco::Engine, at: "/docs"
  namespace 'api' do
    namespace 'v1' do
      mount ActionCable.server => '/cable'
    end
  end
  namespace 'api' do
    namespace 'v1', constraints: ApiConstraint.new(version: 1) do
      devise_for :users, controllers:{ sessions: 'api/v1/users/sessions', registrations: 'api/v1/users/registrations' }
      post 'visitor/question', to: 'visitors#submit_question'
      get 'users/forgot_password', to: 'users#forgot_password'
      post 'users/password/new', to: 'users#new_password'
      get 'users/check_token', to: 'users#check'
      put 'users/resend_code', to: 'users#resend_verification_code'
      put 'users/verify', to: 'users#verify_code'
      get 'users/show', to: 'users#show'
      put "users/update_profile" => "users#update_profile"
      put "users/update_image" => 'users#update_image'

      put "watch_properties" => 'properties#add_watch_properties'
      get "watch_properties" => 'properties#list_favourites_properties'
      get "admin/users", to: 'admins#users_list'
      get "admin/subscribers", to: 'admins#subscribers_list'
      put "admin/users/status", to: 'admins#update_status'

      get 'properties/new', to: 'properties#new'
      put 'properties/submit', to: 'properties#submit_for_review'
      get 'properties/:id', to: 'properties#show'
      get 'properties/:id/edit', to: 'properties#edit'
      post 'properties', to: 'properties#create'
      put 'properties', to: 'properties#update'
      get 'user/properties', to: 'properties#index'
      get 'properties', to: 'properties#public_index'

      post 'register/properties/', to: 'properties#register'
      post 'properties/bids', to: 'bids#create'
      post 'properties/best_offers', to: 'best_offers#create'
      post 'properties/buy_now_offers', to: 'buy_now_offers#create'

      put 'properties/request_status', to: 'properties#request_status'
      put 'properties/share', to: 'properties#share'
      put 'properties/accept_offer', to: 'properties#accept_offer'

      get 'user/chat_rooms', to: 'chat_rooms#index'
      get 'user/chat_rooms/:id/messages', to: 'chat_rooms#show_messages'
      post 'user/chat_rooms/:id/messages', to: 'chat_rooms#create_messages'
      get 'property/:id/offer/:offer_type/:offer_id', to: 'properties#offer_detail'

      post '/subscriber', to: 'subscribers#create'
      post 'promo_codes/apply', to: 'promo_codes#apply_code'
      get 'promo_codes', to: 'promo_codes#show'

      namespace 'admin' do
        get '/promo_codes', to: 'promo_codes#index'
        post '/promo_codes', to: 'promo_codes#create'

        get '/chat_rooms', to: 'chat_rooms#index'
        get '/chat_rooms/:id/messages', to: 'chat_rooms#show_messages'
        post '/chat_rooms/:id/messages', to: 'chat_rooms#create_messages'
        get '/properties', to: 'properties#index'
        put 'properties/status', to: 'properties#update_status'
        post '/properties/sold', to: 'properties#sold_property'
        get '/properties/:id/change_logs', to: 'properties#change_log_details'
        put '/properties/:id/change_logs', to: 'properties#change_log_update'
        get '/activities', to: 'activities#index'
        put '/activities', to: 'activities#update'

        get '/mailer_templates', to: 'notification_mailer_templates#index'
        put '/mailer_templates/:id', to: 'notification_mailer_templates#update'

        get '/message_templates', to: 'notification_message_templates#index'
        put '/message_templates/:id', to: 'notification_message_templates#update'
        put '/test/mailer_templates/:id', to: 'notification_mailer_templates#send_test_mail'
        put '/test/message_templates/:id', to: 'notification_message_templates#send_test_message'
      end
    end
  end
end
