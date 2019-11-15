Rails.application.routes.draw do
  # devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace 'api' do
    namespace 'v1', constraints: ApiConstraint.new(version: 1) do
      devise_for :users, controllers:{ sessions: 'api/v1/users/sessions', registrations: 'api/v1/users/registrations' }
    end
  end
end
