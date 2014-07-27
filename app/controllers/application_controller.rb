class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  serialization_scope :view_context
  skip_before_filter :verify_authenticity_token
  respond_to :json

  decent_configuration do
    strategy DecentExposure::StrongParametersStrategy
  end

end
