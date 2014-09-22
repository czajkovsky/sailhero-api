class MapSerializer < ActiveModel::Serializer
  embed :ids, include: true
  attributes :id, :latitude, :longitude
  has_many :ports
end
