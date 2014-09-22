class Map
  include ActiveModel::SerializerSupport

  attr_reader :latitude, :longitude, :id

  def initialize(latitude, longitude, id)
    @latitude = latitude
    @longitude = longitude
    @id = id
    @port_ids = collection_ids(Port.all)
  end

  def attributes
    { id: nil, port_ids: collection_ids(Port.all) }
  end

  def ports
    serialize_collection(Port.all)
  end

  def collection_ids(collection)
    collection.map { |c| c.id }
  end

  def serialize_collection(collection)
    collection.all.map do |p|
      attributes = {}
      p.attributes.each { |a| attributes.merge!(a: p[a]) }
    end
  end
end
