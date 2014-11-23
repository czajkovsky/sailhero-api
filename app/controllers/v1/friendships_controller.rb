module V1
  class FriendshipsController < VersionController
    doorkeeper_for :all

    before_action :check_if_friendship_exists, only: :create
    before_action :check_if_friend_exists, only: :create
    before_action :prevent_self_friending, only: :create
    before_action :check_if_is_pending, only: [:accept, :deny, :block]
    before_action :check_friendship_owner, only: [:destroy]

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
      render json: Friendship.accepted(current_user)
    end

    def sent
      render json: Friendship.sent(current_user)
    end

    def pending
      render json: Friendship.pending(current_user)
    end

    def show
      render json: friendship
    end

    def accept
      friendship.accept!
      render json: friendship
    end

    def block
      friendship.block!
      render json: friendship
    end

    def deny
      friendship.destroy
      render status: 200, nothing: true
    end

    def destroy
      friendship.destroy
      render status: 200, nothing: true
    end

    private

    def check_friendship_owner
      render status: 403, nothing: true unless friendship.owner?(current_user)
    end

    def check_if_friendship_exists
      existing = Friendship.between_users(current_user.id, params[:friend_id])
      render status: 403, nothing: true unless existing.count.zero?
    end

    def prevent_self_friending
      render status: 462, nothing: true if friend == current_user
    end

    def check_if_friend_exists
      render status: 463, nothing: true if friend.nil?
    end

    def check_if_is_pending
      render status: 403, nothing: true if friendship.friend != current_user
    end

    def friendship_params
      params.require(:friendship).permit(:friend_id)
    end
  end
end
