class MapSerializer < ActiveModel::Serializer
  attributes :id, :latitude, :longitude
  has_many :ports, embed: :ids
end
