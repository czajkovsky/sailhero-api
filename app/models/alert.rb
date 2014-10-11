class Alert < ActiveRecord::Base
  belongs_to :user

  LAT_LANG_FORMAT = /\A[0-9]+\.[0-9]+\Z/i
  ALERT_TYPES = %w( BAD_WEATHER_CONDITIONS CLOSED_AREA YACHT_FAILURE ).freeze

  validates :latitude, :longitude, format: { with: LAT_LANG_FORMAT }
  validates :latitude, :longitude, :alert_type, presence: true
  validates :alert_type, inclusion: { in: ALERT_TYPES }
end
