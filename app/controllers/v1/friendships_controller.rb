module V1
  class FriendshipsController < VersionController
    doorkeeper_for :all

    before_action :check_if_friendship_exists, only: :create
    before_action :prevent_self_friending, only: :create
    before_action :check_if_friend_exists

    expose(:friendship, attributes: :permitted_params)
    expose(:friend) { User.where(id: params[:friend_id]).first }

    def create
      if friendship.save
        friendship.update_attributes(user_id: current_user.id, status: 0)
        render status: 201, json: friendship
      else
        render status: 422, json: { errors: device.errors }
      end
    end

    private

    def check_if_friendship_exists
      friendship_count = Friendship.where(user_id: current_user.id,
                                          friend_id: params[:friend_id]).count
      render status: 403, nothing: true unless friendship_count.zero?
    end

    def prevent_self_friending
      render status: 462, nothing: true if params[:friend_id] == current_user.id
    end

    def check_if_friend_exists
      render status: 463, nothing: true if friend.nil?
    end

    def permitted_params
      params.require(:friendship).permit(:friend_id)
    end
  end
end
