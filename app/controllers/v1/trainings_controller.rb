module V1
  class TrainingsController < RegionRestrictedController
    expose(:trainings)
    expose(:training)

    def index
      render json: trainings
    end

    def create
      if Training.my(current_user).not_finished.count.zero?
        new_training = current_user.trainings.create(started_at: Time.now)
        render status: 201, json: new_training
      else
        render status: 422, json: { errors: [
          I18n.t('active_record.training.errors.already_in_progress')] }
      end
    end
  end
end
