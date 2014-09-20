class YachtSerializer < ActiveModel::Serializer
  attributes :id, :name, :length, :width, :crew
end
