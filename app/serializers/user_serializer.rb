class UserSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :updated_at, :email, :yacht

  def yacht
    object.yacht.nil? ? nil : yacht_hash(object.yacht)
  end

  def yacht_hash(yacht)
    {
      id: yacht.id,
      name: yacht.name,
      length: yacht.length,
      width: yacht.width
      crew: yacht.crew
    }
  end
end
