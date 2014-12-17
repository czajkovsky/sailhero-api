class Message < ActiveRecord::Base
  belongs_to :region
  belongs_to :user
  validates :body, length: { in: 1..3000 }, presence: true
end
