class Message < ActiveRecord::Base
  belongs_to :user

  scope :solved, -> { where(solved: true) }
  scope :unsolved, -> { where(solved: false) }
end
