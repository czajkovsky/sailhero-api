class RouteSerializer < ActiveModel::Serializer
  attributes :name, :id
  has_many :pins
end
