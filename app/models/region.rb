class Region < ActiveRecord::Base
  has_many :users
  has_many :alerts
  has_many :messages
end
