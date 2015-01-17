class Pin < ActiveRecord::Base
  belongs_to :route
  validates :latitude, :longitude, presence: true
end
