module V1
  class UsersController < VersionController
    before_action :authorize!, except: :create
    before_action :self?, only: :update
    before_action :process_image!, only: [:create, :update]
    expose(:user, attributes: :permitted_params)

    def create
      save_user(status: 201, notify: false)
    end

    def update
      save_user(status: 200, notify: true)
    end

    def me
      render status: 200, json: current_resource_owner,
             serializer: Users::ProfileSerializer
    end

    def index
      users = User.active.search(params[:q])
      render status: 200, json: users, each_serializer: Users::FriendSerializer
    end

    def show
      render status: 200, json: user, serializer: Users::FriendSerializer
    end

    private

    def process_image!
      return false unless params[:user][:avatar_data]
      img = ::Base64Decoder.new(params[:user][:avatar_data]).call
      params[:user][:avatar] = img
      params[:user].delete(:avatar_data)
    end

    def self?
      matches_user = (params[:id] == current_user.id.to_s)
      render status: 403, nothing: true unless matches_user
    end

    def save_user(args)
      if user.save
        sync_profile if args[:notify]
        ActivationMailer.confirm_account(user).deliver if args[:status] == 201
        render status: args[:status], json: user,
               serializer: Users::ProfileSerializer
      else
        render status: 422, json: { errors: user.errors }
      end
    end

    def sync_profile
      ProfileNotifier.new(user: user, caller: current_device).call
    end

    def current_resource_owner
      User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
    end

    def permitted_params
      params.require(:user).permit(:email, :password, :password_confirmation,
                                   :name, :surname, :avatar, :share_position)
    end
  end
end
