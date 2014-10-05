module V1
  class TrainingsController < VersionController
    doorkeeper_for :all
    expose(:trainings)
    expose(:training)

    def index
      render json: trainings
    end

    def create
      new_training = current_user.trainings.create(started_at: Time.now)
      render status: 201, json: new_training
    end
  end
end
