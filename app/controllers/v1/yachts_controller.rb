module V1
  class YachtsController < VersionController
    before_action :doorkeeper_authorize!
    before_action :authenticate_yacht_owner, only: [:update, :show]
    before_action :check_if_user_has_yacht, only: :create
    expose(:yacht, attributes: :permitted_params)

    def create
      if yacht.save
        current_user.yacht = yacht
        render status: 201, json: yacht
      else
        render status: 422, json: { errors: yacht.errors }
      end
    end

    def update
      if yacht.save
        render status: 200, json: yacht
      else
        render status: 422, json: { errors: yacht.errors }
      end
    end

    private

    def permitted_params
      params.require(:yacht).permit(:length, :width, :crew, :name)
    end

    def authenticate_yacht_owner
      render nothing: true, status: 403 unless current_user == yacht.user
    end

    def check_if_user_has_yacht
      render nothing: true, status: 461 if current_user.yacht.present?
    end
  end
end
