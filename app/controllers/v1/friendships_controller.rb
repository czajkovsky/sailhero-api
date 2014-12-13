module V1
  class FriendshipsController < VersionController
    doorkeeper_for :all

    before_action :friendship_exists?, only: :create
    before_action :friend_exists?, only: :create
    before_action :prevent_self_friending, only: :create
    before_action :pending?, only: [:accept, :deny]
    before_action :owner?, only: [:cancel]

    expose(:friend) { User.where(id: params[:friend_id]).first }
    expose(:friendship) { repository.fetch(params[:id]) }

    def create
      new_friendship = Friendship.new(friendship_params)
      if new_friendship.save
        new_friendship.update_attributes(user_id: current_user.id, status: 0)
        render status: 201, json: new_friendship
      else
        render status: 422, json: { errors: new_friendship.errors }
      end
    end

    def all
      data = {
        accepted: repository.accepted.serialize,
        sent: repository.sent.serialize,
        pending: repository.pending.serialize
      }
      render json: data
    end

    def index
      render json: repository.accepted.serialize
    end

    def sent
      render json: repository.sent.serialize
    end

    def pending
      render json: repository.pending.serialize
    end

    def show
      render json: friendship.serialize
    end

    def accept
      notify(friendship.friendships.user)
      friendship.friendships.accept!
      render json: friendship.serialize
    end

    def deny
      notify(friendship.user)
      friendship.friendships.destroy
      render status: 200, nothing: true
    end

    def cancel
      notify(friendship.friendships.friend)
      friendship.friendships.destroy
      render status: 200, nothing: true
    end

    private

    def notify(folk)
      GCMPusher.new(data: { message: 'sync_friends' }, collapse_key: 'friend',
                    devices: folk.devices.android.map(&:key)).call
    end

    def repository
      FriendshipRepository.new(current_user)
    end

    def owner?
      render status: 403, nothing: true unless friendship.friendships.owner?(current_user)
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
      render status: 403, nothing: true if friendship.friendships.friend != current_user
    end

    def friendship_params
      params.require(:friendship).permit(:friend_id)
    end

    def serialize_friendships_array(friendships_array)
      ActiveModel::ArraySerializer.new(friendships_array,
                                       each_serializer: FriendshipSerializer)
    end
  end
end
