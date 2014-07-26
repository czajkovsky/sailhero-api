Rails.application.routes.draw do
  use_doorkeeper

  devise_for :users

  constraints subdomain: 'api' do
    namespace :v1 do
      resources :places
      resources :users
    end
  end

end
