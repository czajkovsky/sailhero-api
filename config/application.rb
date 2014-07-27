require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module SailheroApi
  class Application < Rails::Application

    config.middleware.insert_before ActionDispatch::ShowExceptions, Rack::Cors do
      allow do
        origins '*'
        resource '*',
          :headers => :any,
          :methods => [:get, :post, :put, :patch, :delete, :options]
      end
    end

  end
end
