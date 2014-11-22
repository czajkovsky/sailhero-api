class AlertSerializer < ActiveModel::Serializer
  attributes :id, :latitude, :longitude, :alert_type, :additional_info,
             :created_at, :user_id, :credibility, :active
end
