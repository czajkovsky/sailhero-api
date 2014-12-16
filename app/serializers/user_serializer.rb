class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :surname, :created_at, :updated_at, :email,
             :last_position, :avatar_url, :share_position
  has_one :yacht, include: true
  has_one :region, include: :true

  def last_position
    { latitude: object.latitude, longitude: object.latitude,
      updated_at: object.position_updated_at }
  end

  def avatar_url
    object.avatar.url
  end
end
