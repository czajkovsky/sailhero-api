Rails.application.routes.draw do

  constraints subdomain: 'api' do
    namespace :v1 do
      resources :users
      resources :places
    end
  end

end
