Rails.application.routes.draw do
  # devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  mount Apidoco::Engine, at: "/docs"
  namespace 'api' do
    namespace 'v1', constraints: ApiConstraint.new(version: 1) do
      devise_for :users, controllers:{ sessions: 'api/v1/users/sessions', registrations: 'api/v1/users/registrations' }
      get 'users/check_token', to: 'users#check'
    end
  end
end
