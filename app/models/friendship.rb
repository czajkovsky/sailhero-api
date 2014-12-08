class Friendship < ActiveRecord::Base
  belongs_to :user
  belongs_to :friend, class_name: 'User'
  attr_accessor :invited

  def self.between_users(inviter_id, invited_id)
    request = 'user_id = ? and friend_id = ? or user_id = ? and friend_id = ?'
    where(request, inviter_id, invited_id, invited_id, inviter_id)
  end

  def self.accepted(user)
    request = 'status = 1 and (user_id = ? or friend_id = ?)'
    assign_side(user, where(request, user.id, user.id))
  end

  def self.sent(user)
    assign_side(user, where(status: 0, user_id: user.id))
  end

  def self.pending(user)
    assign_side(user, where(status: 0, friend_id: user.id))
  end

  def self.assign_side(user, friendships)
    friendships.each { |f| f.invited = (f.friend_id == user.id) }
  end

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

  def accept!
    update_attributes(status: 1)
  end

  def block!
    update_attributes(status: 2)
  end
end
