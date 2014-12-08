module V1
  module Doorkeeper
    class TokensController < ::Doorkeeper::TokensController
      def revoke
        Device.where(token_id: doorkeeper_token.id).destroy_all
        super
      end
    end
  end
end
