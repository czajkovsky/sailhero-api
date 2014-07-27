module V1
  class PlacesController < VersionController
    doorkeeper_for :all
    expose(:places)
    expose(:place, attributes: :permitted_params)

    def index
      render json: places
    end

    def create
      if place.save
        render json: place, status: :created
      else
        render json: place.errors, status: 422
      end
    end

    def permitted_params
      params.require(:place).permit(:name)
    end

  end
end
