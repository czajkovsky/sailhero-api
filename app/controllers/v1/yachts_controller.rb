module V1
  class YachtsController < VersionController
    expose(:yacht, attributes: :permitted_params)

    def create
      if yacht.save
        current_user.yacht = yacht
        render status: 201, json: yacht
      else
        render status: 422, json: { errors: yacht.errors }
      end
    end

    def permitted_params
      params.require(:yacht).permit(:length, :width, :crew, :name)
    end
  end
end
