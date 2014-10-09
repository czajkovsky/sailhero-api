module V1
  class CheckpointsController < VersionController
    expose(:training)
    expose(:accepted) { [] }
    expose(:rejected) { [] }

    def create
      params[:checkpoints].each(&method(:save_checkpoint))
      render status: 201, json: { accepted: accepted, rejected: rejected }
    end

    private

    def save_checkpoint(checkpoint)
      cp = training.checkpoints.new(checkpoint.permit(:timestamp, :latitude,
                                                      :longitude))
      cp.save ? accepted << cp.timestamp : rejected << cp.timestamp
    end
  end
end
