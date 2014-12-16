module Users
  class FriendSerializer < BaseSerializer
    attributes :id, :name, :surname, :email, :avatar_url
  end
end
