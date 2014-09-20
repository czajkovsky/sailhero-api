module V1
  class YachtsController < VersionController
    expose(:yacht, attributes: :permitted_params)

    def create
      if yacht.save
        current_user.yacht = yacht if current_user.yacht.nil?
        render status: 201, json: yacht
      else
        render status: 422, json: { errors: yacht.errors }
      end
    end

    def update
      render nothing: true, status: 403 unless current_user == yacht.user
      if yacht.save
        render status: 200, json: yacht
      else
        render status: 422, json: { errors: yacht.errors }
      end
    end

    def permitted_params
      params.require(:yacht).permit(:length, :width, :crew, :name)
    end
  end
end
