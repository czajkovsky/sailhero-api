module Requests
  module AppHelpers
    def create_client_app(name = 'MyApp', redirect_uri = 'https://app.com')
      Doorkeeper::Application.create!(name: name,
                                      redirect_uri: redirect_uri)
    end

    def access_token(app, user)
      Doorkeeper::AccessToken.create!(application_id: app.id,
                                      resource_owner_id: user.id)
    end

    def user_params(name, surname, email, active = true)
      { name: name, surname: surname, email: email, active: active }
    end

    def create_login_params(user, app)
      {
        client_id: app.uid,
        client_secret: app.secret,
        username: user.email,
        grant_type: 'password',
        password: user.password
      }
    end

    def create_friendship(user, friend)
      create(:friendship, user_id: user.id, friend_id: friend.id, status: 1)
    end
  end
end
