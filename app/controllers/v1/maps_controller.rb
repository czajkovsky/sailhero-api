module V1
  class MapsController < RegionRestrictedController
    def show
      latitude, longitude = params[:location].split('@')
      map = ::Map.new(latitude, longitude, params[:location])
      render status: 200, json: map
    end
  end
end
