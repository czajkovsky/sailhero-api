Rails.application.routes.draw do
  use_doorkeeper

  constraints subdomain: 'api' do
    namespace :v1 do
      scope '/:locale' do
        resources :places
        resources :users
        resources :messages, only: [:index, :create, :show] do
          resources :replies, only: [:create, :index]
        end
        resources :yachts, only: [:create]
        namespace :map do
          resources :ports, only: [:index, :show] do
            member do
              get 'calculate'
            end
          end
          resources :channels, only: [:index, :show]
          resources :routes, only: [:index, :show]
          resources :dangers, only: [:index, :show]
        end
        get 'me', to: 'credentials#me'
      end
    end
  end
end
