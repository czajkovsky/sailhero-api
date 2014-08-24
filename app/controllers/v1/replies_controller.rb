module V1
  class RepliesController < VersionController
    expose(:replies)
    expose(:message)

    def index
      render json: message.replies
    end
  end
end
