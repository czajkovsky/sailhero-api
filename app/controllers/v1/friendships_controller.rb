module V1
  class FriendshipsController < VersionController
    doorkeeper_for :all

    before_action :friendship_exists?, only: :create
    before_action :friend_exists?, only: :create
    before_action :prevent_self_friending, only: :create
    before_action :pending?, only: [:accept, :deny]
    before_action :owner?, only: [:cancel]

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
      notify(friendship.user)
      friendship.destroy!
      render status: 200, nothing: true
    end

    def cancel
      notify(friendship.friendship.friend)
      friendship.destroy!
      render status: 200, nothing: true
    end

    private

    def notify(folk)
      GCMPusher.new(data: { message: 'sync_friends' }, collapse_key: 'friend',
                    devices: folk.devices.android.map(&:key)).call
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

    def friendship_exists?
      existing = Friendship.between_users(current_user.id, params[:friend_id])
      render status: 403, nothing: true unless existing.count.zero?
    end

    def prevent_self_friending
      render status: 462, nothing: true if friend == current_user
    end

    def friend_exists?
      render status: 463, nothing: true if friend.nil?
    end

    def pending?
      render status: 403, nothing: true unless friendship.waiting_for_user?
    end

    def friendship_params
      params.require(:friendship).permit(:friend_id)
    end
  end
end
