module V1
  class CredentialsController < VersionController
    doorkeeper_for :all

    def me
      respond_with current_resource_owner
    end

    private

    def current_resource_owner
      User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
    end
  end
end
