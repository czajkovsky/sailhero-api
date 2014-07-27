class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  serialization_scope :view_context
  respond_to :json

  decent_configuration do
    strategy DecentExposure::StrongParametersStrategy
  end

end
