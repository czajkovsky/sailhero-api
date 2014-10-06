class UserSerializer < ActiveModel::Serializer
  attributes :id, :name, :surname, :created_at, :updated_at, :email,
             :last_position, :region_id
  has_one :yacht, embed: :id, include: true

  def last_position
    { latitude: object.latitude, longitude: object.latitude,
      updated_at: object.position_updated_at }
  end
end
