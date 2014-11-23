module V1
  class FriendshipsController < VersionController
    doorkeeper_for :all

    before_action :check_if_friendship_exists, only: :create
    before_action :check_if_friend_exists, only: :create
    before_action :prevent_self_friending, only: :create

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

    def index
      request = 'status = 1 and (user_id = ? or friend_id = ?)'
      accepted = Friendship.where(request, current_user.id, current_user.id)
      render json: accepted
    end

    def sent
      sent = Friendship.where(status: 0, user_id: current_user.id)
      render json: sent
    end

    private

    def check_if_friendship_exists
      request = 'user_id = ? and friend_id = ? or user_id = ? and friend_id = ?'
      count = Friendship.where(request, current_user.id, params[:friend_id],
                               params[:friend_id], current_user.id).count
      render status: 403, nothing: true unless count.zero?
    end

    def prevent_self_friending
      render status: 462, nothing: true if friend == current_user
    end

    def check_if_friend_exists
      render status: 463, nothing: true if friend.nil?
    end

    def permitted_params
      params.require(:friendship).permit(:friend_id)
    end
  end
end
