class Friendship < ActiveRecord::Base
  belongs_to :user
  belongs_to :friend, class_name: 'User'

  STATES = %w( pending accepted blocked ).freeze

  def accepted?
    status == 1
  end

  def pending?
    status == 0
  end

  def blocked?
    status == 2
  end

  def owner?(user)
    user.id == friend_id || user.id == user_id
  end
end
