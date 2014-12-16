module Users
  class BaseSerializer < ActiveModel::Serializer
    root 'user'

    def last_position
      return nil unless object.share_position
      { latitude: object.latitude, longitude: object.longitude,
        updated_at: object.position_updated_at }
    end

    def avatar_url
      object.avatar.url
    end
  end
end
