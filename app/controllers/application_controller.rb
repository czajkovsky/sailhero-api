class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  serialization_scope :view_context
  skip_before_filter :verify_authenticity_token
  respond_to :json
  before_action :set_locale
  helper_method :current_user

  decent_configuration do
    strategy DecentExposure::StrongParametersStrategy
  end

  def authorize!
    render nothing: true, status: 401 if current_user.nil?
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  private

  def current_user
    @current_user = doorkeeper_token.present? ? find_current_user : nil
  end

  def find_current_user
    User.find(doorkeeper_token.resource_owner_id)
  end
end
