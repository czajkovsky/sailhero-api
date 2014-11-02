class DeviceSerializer < ActiveModel::Serializer
  attributes :id, :name, :device_type, :key, :created_at
end
