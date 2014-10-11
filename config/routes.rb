Rails.application.routes.draw do
  use_doorkeeper

  scope :api do
    namespace :v1 do
      scope '(:locale)', locale: /en|pl/ do

        resources :users do
          get 'me', on: :collection
          delete 'me', on: :collection, to: 'users#deactivate_profile'
        end

        resources :regions, only: :index do
          post 'select', on: :member, to: 'regions#select'
        end

        resources :messages, only: [:index, :create, :show] do
          resources :replies, only: [:create, :index]
        end

        resources :trainings do
          resources :checkpoints, only: [:create]
        end

        resources :alerts, except: [:update, :edit, :destroy]

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
