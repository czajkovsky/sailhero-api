class Pin < ActiveRecord::Base
  belongs_to :route

  LAT_LANG_FORMAT = /\A[0-9]+\.[0-9]+\Z/i
  validates :latitude, :longitude, format: { with: LAT_LANG_FORMAT }
  validates :latitude, :longitude, presence: true
end
