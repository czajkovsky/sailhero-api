class Device < ActiveRecord::Base
  belongs_to :user

  DEVICE_TYPES = %w( ANDROID ).freeze

  validates :device_type, inclusion: { in: DEVICE_TYPES }
  validates :name, :key, :device_type, presence: true
  validates :key, uniqueness: true

  scope :android, -> { where(device_type: 'ANDROID') }
end
