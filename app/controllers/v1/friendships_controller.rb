module V1
  class FriendshipsController < VersionController
    doorkeeper_for :all
    expose(:friendship, attributes: :permitted_params)
    before_action :prevent_self_friending, only: :create

    def create
      if friendship.save
        friendship.update_attributes(user_id: current_user.id, status: 0)
        render status: 201, json: friendship
      else
        render status: 422, json: { errors: device.errors }
      end
    end

    private

    def prevent_self_friending
      render status: 462, nothing: true if params[:friend_id] == current_user.id
    end

    def permitted_params
      params.require(:friendship).permit(:friend_id)
    end
  end
end
