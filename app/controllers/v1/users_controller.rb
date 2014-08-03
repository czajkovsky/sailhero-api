module V1
  class UsersController < VersionController
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

    def permitted_params
      params.require(:user).permit(:email, :password, :password_confirmation,
                                   :name, :surname)
    end
  end
end
