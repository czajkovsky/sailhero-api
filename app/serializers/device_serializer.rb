class DeviceSerializer < ActiveModel::Serializer
  attributes :id, :name, :device_type, :created_at
end
