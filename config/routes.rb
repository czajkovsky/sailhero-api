Rails.application.routes.draw do
  use_doorkeeper

  scope :api do
    namespace :v1 do
      scope '(:locale)', locale: /en|pl/ do

        resources :users, except: :index do
          collection do
            get 'me'
            delete 'me', to: 'users#deactivate_profile'
            post 'me/devices', to: 'devices#create'
          end
        end

        resources :regions, only: :index do
          post 'select', on: :member, to: 'regions#select'
        end

        resources :messages, only: [:index, :create, :show] do
          resources :replies, only: [:create, :index]
        end

        resources :trainings do
          resources :checkpoints, only: :create
        end

        resources :friendships do
          collection do
            get 'sent'
            get 'pending'
          end
          member do
            post 'accept'
            post 'block'
            post 'deny'
          end
        end

        resources :alerts, except: [:update, :edit, :destroy] do
          post 'confirmations', on: :member, to: 'alert_confirmations#create'
          delete 'confirmations', on: :member, to: 'alert_confirmations#destroy'
        end

        resources :yachts, except: :index

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
