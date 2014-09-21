module RequestsHelper
  def create_client_app(name = 'MyApp', redirect_uri = 'http://app.com')
    Doorkeeper::Application.create!(name: name,
                                    redirect_uri: redirect_uri)
  end

  def access_token(app, user)
    Doorkeeper::AccessToken.create!(application_id: app.id,
                                    resource_owner_id: user.id)
  end
end
