module V1
  class GcmController < VersionController
    doorkeeper_for :all

    def create
      gcm = Gcm.create(key: params[:gcm][:key], token_id: doorkeeper_token.id)
      render json: gcm, status: 201
    end
  end
end
