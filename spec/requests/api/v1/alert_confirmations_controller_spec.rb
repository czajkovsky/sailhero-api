require 'spec_helper'

describe V1::AlertConfirmationsController, type: :controller do

  let(:region) { create(:region) }
  let(:reporter) { create(:user, region_id: region.id) }
  let(:confirmer) { create(:user, region_id: region.id, email: 'b@test.com') }
  let(:confirmer2) { create(:user, region_id: region.id, email: 'c@test.com') }
  let(:alert) { create(:alert, user_id: reporter.id) }

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
    let(:reporter_token) { access_token(app, reporter) }
    let(:confirmer_token) { access_token(app, confirmer) }
    let(:confirmer2_token) { access_token(app, confirmer2) }

    describe 'POST#create' do

      it 'blocks self confirmation with 403 status code' do
        post :create, id: alert, access_token: reporter_token.token
        alert.reload
        expect(alert.credibility).to eq(0)
        expect(response).to have_http_status(403)
      end

      it 'up votes alert' do
        controller.stub(:doorkeeper_token) { confirmer_token }
        post :create, id: alert
        controller.stub(:doorkeeper_token) { confirmer2_token }
        post :create, id: alert
        alert.reload
        expect(alert.credibility).to eq(2)
        expect(response).to have_http_status(200)
      end
    end

    describe 'DELETE#destroy' do

      it 'blocks self confirmation with 403 status code' do
        delete :destroy, id: alert, access_token: reporter_token.token
        alert.reload
        expect(alert.credibility).to eq(0)
        expect(response).to have_http_status(403)
      end

      it 'down votes alert' do
        delete :destroy, id: alert, access_token: confirmer_token.token
        alert.reload
        expect(alert.credibility).to eq(-1)
        expect(alert.active).to eq(false)
        expect(Alert.active.count).to eq(0)
      end

      it 'down removes previous vote for alert' do
        controller.stub(:doorkeeper_token) { confirmer_token }
        post :create, id: alert # 1
        delete :destroy, id: alert # -1
        controller.stub(:doorkeeper_token) { confirmer2_token }
        post :create, id: alert
        expect(response).to have_http_status(404)
      end
    end
  end
end
