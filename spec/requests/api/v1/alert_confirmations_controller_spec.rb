require 'spec_helper'

describe V1::AlertConfirmationsController, type: :controller do

  let(:region) { create(:region) }
  let(:user) { create(:user, region_id: region.id) }
  let(:alert) { create(:alert, user_id: user.id) }

  context 'for unauthenticated user' do

    describe 'POST#create' do
      it 'denies access with 401 status code' do
        post :create, id: alert
        expect(response).to have_http_status(401)
      end
    end

    describe 'DELETE#destroy' do
      it 'denies access with 401 status code' do
        delete :destroy, id: alert
        expect(response).to have_http_status(401)
      end
    end
  end

  context 'user is authenticated' do

    let(:app) { create_client_app }
    let(:token) { access_token(app, user) }
    let(:alert_params) { FactoryGirl.attributes_for(:alert) }

    describe 'POST#create' do

      it 'blocks self confirmation with 403 status code' do
        post :create, id: alert, access_token: token.token
        alert.reload
        expect(alert.credibility).to eq(0)
        expect(response).to have_http_status(403)
      end
    end
  end
end
