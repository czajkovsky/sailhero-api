class Route < ActiveRecord::Base
  belongs_to :region
  has_many :pins
end
