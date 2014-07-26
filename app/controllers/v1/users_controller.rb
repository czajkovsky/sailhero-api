module V1
  class UsersController < VersionController
    expose(:users)
    expose(:user, attributes: :permitted_params)

    def index
      render json: users
    end

    def create
      if user.save
        render json: user, status: :created
      else
        render json: user.errors, status: 422
      end
    end

    def permitted_params
      params.require(:user).permit(:email, :password)
    end

  end
end
