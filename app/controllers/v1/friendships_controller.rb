module V1
  class FriendshipsController < VersionController
    doorkeeper_for :all

    before_action :check_if_friendship_exists, only: :create
    before_action :check_if_friend_exists, only: :create
    before_action :prevent_self_friending, only: :create

    expose(:friendship)
    expose(:friend) { User.where(id: params[:friend_id]).first }

    def create
      new_friendship = Friendship.new(friendship_params)
      if new_friendship.save
        new_friendship.update_attributes(user_id: current_user.id, status: 0)
        render status: 201, json: new_friendship
      else
        render status: 422, json: { errors: new_friendship.errors }
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

    def pending
      pending = Friendship.where(status: 0, friend_id: current_user.id)
      render json: pending
    end

    def show
      render json: friendship
    end

    def accept
      friendship.update_attributes(status: 1)
      render json: friendship
    end

    def block
      friendship.update_attributes(status: 2)
      render json: friendship
    end

    def deny
      friendship.destroy
      render status: 200, nothing: true
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

    def friendship_params
      params.require(:friendship).permit(:friend_id)
    end
  end
end
