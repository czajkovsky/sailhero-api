class ApplicationController < ActionController::Base
  protect_from_forgery with: :null_session
  serialization_scope :view_context
  respond_to :json

  before_action :set_locale
  before_action :update_current_position
  skip_before_filter :verify_authenticity_token

  helper_method :current_user
  helper_method :current_region
  helper_method :current_device

  decent_configuration do
    strategy DecentExposure::StrongParametersStrategy
  end

  def authorize!
    render nothing: true, status: 401 if current_user.nil?
  end

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def update_current_position
    latitude = request.env['HTTP_X-Sailhero-Latitude']
    longitude = request.env['HTTP_X-Sailhero-Longitude']
    return false if latitude.nil? || longitude.nil? || current_user.nil?
    current_user.update_attributes(latitude: latitude, longitude: longitude,
                                   position_updated_at: Time.now)
    params[:latitude] = latitude
    params[:longitude] = longitude
  end

  private

  def current_user
    @current_user = valid_token? ? find_current_user : nil
  end

  def current_region
    @current_region = current_user ? current_user.region : nil
  end

  def current_device
    @current_device = Device.where(token_id: doorkeeper_token.id).first
  end

  def valid_token?
    token = doorkeeper_token
    token.present? && token.valid? && !token.expired? && !token.revoked?
  end

  def find_current_user
    User.find(doorkeeper_token.resource_owner_id)
  end
end
