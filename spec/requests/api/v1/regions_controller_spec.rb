require 'spec_helper'

describe V1::RegionsController, type: :controller do

  let(:region) { create(:region) }
  let(:user) { create(:user, region_id: region.id) }
  let(:user_without_region) { create(:user) }

  context 'for unauthenticated user' do

    describe 'GET#index' do
      it 'denies access with 401 status code' do
        get :index
        expect(response).not_to be_success
        expect(response).to have_http_status(401)
      end
    end
  end

  context 'user is authenticated' do

    let(:app) { create_client_app }
    let(:token) { access_token(app, user) }

    describe 'GET#index' do
      it 'renders OK response' do
        get :index, access_token: token.token
        expect(response).to be_success
        expect(response).to have_http_status(200)
      end
    end
  end
end
