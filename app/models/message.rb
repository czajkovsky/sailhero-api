class Message < ActiveRecord::Base
  belongs_to :user
  has_many :replies

  scope :solved, -> { where(solved: true) }
  scope :unsolved, -> { where(solved: false) }
end
