module Requests
  module AppHelpers
    def create_client_app(name = 'MyApp', redirect_uri = 'http://app.com')
      Doorkeeper::Application.create!(name: name,
                                      redirect_uri: redirect_uri)
    end

    def access_token(app, user)
      Doorkeeper::AccessToken.create!(application_id: app.id,
                                      resource_owner_id: user.id)
    end

    def user_params(name, surname, email)
      { name: name, surname: surname, email: email }
    end
  end
end
