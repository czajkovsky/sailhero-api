Rails.application.routes.draw do
  get 'activate', to: 'activations#activate'

  scope :api do
    namespace :v1 do
      scope '(:locale)', locale: /en|pl/ do
        scope 'oauth' do
          post 'token', to: 'doorkeeper/tokens#create'
          post 'revoke', to: 'doorkeeper/tokens#revoke'
        end

        resources :users, only: [:update, :index, :create, :show] do
          collection do
            get 'me'
            post 'me/devices', to: 'devices#create'
          end
        end

        resources :regions, only: :index do
          post 'select', on: :member, to: 'regions#select'
        end

        resources :messages, only: [:index, :create, :show]

        resources :friendships, only: [:index, :show, :create] do
          collection do
            get 'sent'
            get 'pending'
            get 'accepted'
          end
          member do
            post 'accept'
            post 'deny'
            post 'cancel'
          end
        end

        resources :alerts, only: [:index, :create, :show] do
          post 'confirmations', on: :member, to: 'alert_confirmations#create'
          delete 'confirmations', on: :member, to: 'alert_confirmations#destroy'
        end

        resources :yachts, only: [:index, :create, :show, :update, :destroy]

        namespace :map do
          resources :ports, only: [:index, :show] do
            get 'calculate', on: :member
          end
          resources :friends, only: [:index]
          resources :routes, only: [:index, :show]
        end
      end
    end
  end
end
