module V1
  class MapsController < VersionController
    def show
      latitude, longitude, zoom = params[:location].split('@')
      render status: 200, json: { map: { id: params[:location], latitude: latitude, longitude: longitude, zoom: zoom } }
    end
  end
end
