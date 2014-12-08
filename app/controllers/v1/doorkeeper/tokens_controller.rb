module V1
  module Doorkeeper
    class TokensController < ::Doorkeeper::TokensController
      def revoke
        super
      end
    end
  end
end
