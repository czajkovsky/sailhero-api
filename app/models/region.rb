class Region < ActiveRecord::Base
  has_many :users
  has_many :alerts
  has_many :messages
  has_many :routes
  has_many :ports

  validates :full_name, :code_name, presence: true
  validates :code_name, uniqueness: true
end
