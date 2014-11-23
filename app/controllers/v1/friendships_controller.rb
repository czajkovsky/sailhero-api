module V1
  class FriendshipsController < VersionController
    doorkeeper_for :all
    expose(:friendship, attributes: :permitted_params)
    before_action :prevent_self_friending, only: :create

    def create
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
