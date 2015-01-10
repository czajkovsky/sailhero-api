module V1
  module Map
    class FriendsController < VersionController
      before_action :doorkeeper_authorize!

      def index
        render json: friends, each_serializer: Users::NeighbourSerializer
      end

      private

      def friends
        current_user.friends.where(share_position: true)
      end
    end
  end
end
