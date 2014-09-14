require 'spec_helper'

describe V1::UsersController, type: :controller do

  context 'for unauthenticated user' do

    describe 'GET#me' do
      it 'denies access with 401 status code' do
        get :me
        expect(response).not_to be_success
        expect(response).to have_http_status(401)
      end
    end
  end
end
