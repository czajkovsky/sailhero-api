module RequestsHelpers
  def create_client_app
    Doorkeeper::Application.create!(name: 'MyApp',
                                    redirect_uri: 'http://app.com')
  end
end
