class Map
  include ActiveModel::Serialization
  include ActiveModel::SerializerSupport

  attr_accessor :latitude, :longitude, :id, :ports

  def initialize(latitude, longitude, id)
    @latitude = latitude
    @longitude = longitude
    @id = id
  end

  def ports
    Port.all
  end
end
