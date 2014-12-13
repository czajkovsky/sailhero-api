class Friendship < ActiveRecord::Base
  belongs_to :user
  belongs_to :friend, class_name: 'User'

  def self.between_users(inviter_id, invited_id)
    request = 'user_id = ? and friend_id = ? or user_id = ? and friend_id = ?'
    where(request, inviter_id, invited_id, invited_id, inviter_id)
  end

  def accepted?
    status == 1
  end

  def pending?
    status == 0
  end
end
