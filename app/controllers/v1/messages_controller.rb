module V1
  class MessagesController < RegionRestrictedController
    before_filter :check_region, only: :show
    before_filter :check_since_param, only: :index
    expose(:message, attributes: :permitted_params)

    def index
      render json: messages_repository.all
    end

    def create
      save_additional_data(current_user, current_user.region_id,
                           params[:latitude], params[:longitude])
      if message.save
        MessageNotifier.new(message: message).call
        render status: 201, json: message
      else
        render status: 422, json: { errors: message.errors }
      end
    end

    def show
      render json: message
    end

    private

    def check_since_param
      return unless params[:since].nil?
      params[:since] = current_region.messages.last.id
      params[:order] = 'DESC'
    end

    def check_region
      render status: 460, nothing: true unless message.region == current_region
    end

    def messages_repository
      region_id = current_region.id
      MessagesRepository.new(region_id: region_id, limit: params[:limit],
                             order: params[:order], since: params[:since])
    end

    def permitted_params
      params.require(:message).permit(:body)
    end

    def save_additional_data(user, region_id, latitude, longitude)
      message.update_attributes(user: user, region_id: region_id,
                                latitude: latitude, longitude: longitude)
    end
  end
end
