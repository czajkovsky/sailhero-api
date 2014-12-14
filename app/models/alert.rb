class Alert < ActiveRecord::Base
  belongs_to :user
  belongs_to :region
  has_many :confirmations, class_name: 'AlertConfirmation'
  attr_accessor :user_vote

  LAT_LANG_FORMAT = /\A[0-9]+\.[0-9]+\Z/i
  ALERT_TYPES = %w( BAD_WEATHER_CONDITIONS CLOSED_AREA YACHT_FAILURE ).freeze
  INACTIVE_TRESHOLD = 0

  validates :latitude, :longitude, format: { with: LAT_LANG_FORMAT }
  validates :latitude, :longitude, :alert_type, presence: true
  validates :alert_type, inclusion: { in: ALERT_TYPES }

  scope :active, -> { where(active: true) }

  def assign_user_vote(confirmation)
    self.user_vote = 0 if confirmation.nil?
    self.user_vote = (confirmation.up ? 1 : -1) if confirmation.present?
  end
end
