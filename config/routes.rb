Rails.application.routes.draw do
  use_doorkeeper

  scope :api do
    namespace :v1 do
      scope '(:locale)', locale: /en|pl/ do
        resources :places
        resources :users do
          get 'me', on: :collection
          delete 'me', on: :collection, to: 'users#deactivate_profile'
        end
        post 'heartbeat', to: 'heartbeat#index'
        resources :messages, only: [:index, :create, :show] do
          resources :replies, only: [:create, :index]
        end
        resources :trainings do
          resources :checkpoints, only: [:create]
        end
        resources :yachts, except: [:index]
        get 'maps/:location', to: 'maps#show'
        namespace :map do
          resources :ports, only: [:index, :show] do
            get 'calculate', on: :member
          end
          resources :channels, only: [:index, :show]
          resources :routes, only: [:index, :show]
          resources :dangers, only: [:index, :show]
        end
      end
    end
  end
end
