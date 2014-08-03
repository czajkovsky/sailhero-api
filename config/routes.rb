Rails.application.routes.draw do
  use_doorkeeper

  constraints subdomain: 'api' do
    namespace :v1 do
      resources :places
      resources :users
      resources :messages, only: [:index, :create, :show]
    end
  end
end
