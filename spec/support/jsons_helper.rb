module Requests
  module JsonsHelpers
    def json
      @json = Hashie::Mash.new(JSON.parse(response.body))
    end
  end
end
