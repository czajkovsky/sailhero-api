module V1
  class UsersController < VersionController
    before_action :authorize!, except: :create
    before_action :self?, only: :update
    expose(:user, attributes: :permitted_params)

    def create
      save_user(201)
    end

    def update
      save_user(200)
    end

    def me
      render status: 200, json: current_resource_owner
    end

    def index
      users = User.search(params[:q])
      render status: 200, json: users, each_serializer: UserSerializer
    end

    def deactivate_profile
      current_resource_owner.update_attributes(active: false)
      doorkeeper_token.update_attributes(revoked_at: Time.now)
      render nothing: true, status: 200
    end

    private

    def self?
      matches_user = (params[:id] == current_user.id.to_s)
      render status: 403, nothing: true unless matches_user
    end

    def save_user(status)
      if user.save
        render status: status, json: user
      else
        render status: 422, json: { errors: user.errors }
      end
    end

    def current_resource_owner
      User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
    end

    def permitted_params
      params.require(:user).permit(:email, :password, :password_confirmation,
                                   :name, :surname)
    end
  end
end
