module V1
  class UsersController < VersionController
    before_action :authorize!, except: [:create]
    before_action :check_params, only: [:create]
    expose(:users)
    expose(:user, attributes: :permitted_params)

    def index
      render json: users
    end

    def create
      if user.save
        render status: 201, json: user
      else
        render status: 422, json: { errors: user.errors }
      end
    end

    def me
      render status: 200, json: current_resource_owner
    end

    def deactivate_profile
      current_resource_owner.update_attributes(active: false)
      doorkeeper_token.update_attributes(revoked_at: Time.now)
      render nothing: true, status: 200
    end

    private

    def current_resource_owner
      User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
    end

    def check_params
      render nothing: true, status: 422 unless params.key?('user')
    end

    def permitted_params
      params.require(:user).permit(:email, :password, :password_confirmation,
                                   :name, :surname)
    end
  end
end
