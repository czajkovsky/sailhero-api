module V1
  class FriendshipsController < VersionController
    doorkeeper_for :all

    before_action :pending?, only: [:accept, :deny]
    before_action :owner?, only: :cancel
    before_action :createable?, only: :create

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
      render json: friendships.all
    end

    %w(accepted sent pending).each do |state|
      define_method(state) { render json: friendships.send(state).serialize }
    end

    def show
      render json: friendship.serialize
    end

    def accept
      notify(friendship.friendship.user)
      friendship.accept!
      render json: friendship.serialize
    end

    def deny
      FriendshipNotifier.new(friendship.user).call
      friendship.destroy!
      render status: 200, nothing: true
    end

    def cancel
      FriendshipNotifier.new(friendship.friendship.friend).call
      friendship.destroy!
      render status: 200, nothing: true
    end

    private

    def notify(folk)
      FriendshipNotifier.new(folk).call
    end

    def friend
      User.where(id: params[:friend_id]).first
    end

    def friendships
      FriendshipsRepository.new(current_user)
    end

    def friendship
      FriendshipRepository.new(current_user, params[:id])
    end

    def owner?
      render status: 403, nothing: true unless friendship.allowed?
    end

    def createable?
      validator = FriendshipRepositoryValidator.new(current_user, friend).call
      render status: validator.status, nothing: true unless validator.valid?
    end

    def pending?
      render status: 403, nothing: true unless friendship.waiting_for_user?
    end

    def friendship_params
      params.require(:friendship).permit(:friend_id)
    end
  end
end
