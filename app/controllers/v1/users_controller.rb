module V1
  class UsersController < VersionController
    expose(:users)
    expose(:user, attributes: :permitted_params)

    def index
      render json: users
    end

    def create
      render status: 422 if params[:user].empty?
      if user.save
        render status: 201, json: user
      else
        render status: 422, json: { errors: user.errors }
      end
    end

    def me
      render status: 201, json: current_resource_owner
    end

    private

    def current_resource_owner
      User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
    end

    def permitted_params
      params.require(:user).permit(:email, :password, :password_confirmation,
                                   :name, :surname)
    end
  end
end
