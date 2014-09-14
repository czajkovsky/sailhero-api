require 'spec_helper'

describe 'Users API' do

  context 'for unauthenticated user' do
    it 'denies access' do
      get '/api/v1/en/users/me'
    end
  end
end
