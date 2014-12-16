module Users
  class ProfileSerializer < BaseSerializer
    attributes :id, :name, :surname, :created_at, :updated_at, :email,
               :last_position, :avatar_url, :share_position
    has_one :yacht, include: true
    has_one :region, include: :true
  end
end
