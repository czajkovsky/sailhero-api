Rails.application.routes.draw do
  use_doorkeeper

  constraints subdomain: 'api' do
    namespace :v1 do
      resources :places
    end
    scope :v1 do
      devise_for :users
    end
  end

end
