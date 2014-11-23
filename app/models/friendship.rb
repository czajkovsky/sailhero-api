class Friendship < ActiveRecord::Base
  belongs_to :user
  belongs_to :friend, class_name: 'User'

  STATES = %w( pending accepted blocked ).freeze
end
