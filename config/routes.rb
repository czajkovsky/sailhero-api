Rails.application.routes.draw do
  use_doorkeeper

  constraints subdomain: 'api' do
    namespace :v1 do
      resources :places
      resources :users
      resources :messages, only: [:index, :create, :show] do
        resources :replies, only: [:create, :index]
      end
      namespace :map do
        resources :ports, only: [:index, :show]
        resources :channels, only: [:index, :show]
        resources :routes, only: [:index, :show]
        resources :dangers, only: [:index, :show]
      end
    end
  end
end
