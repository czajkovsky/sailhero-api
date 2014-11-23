require 'spec_helper'

describe V1::AlertsController, type: :controller do

  let(:region) { create(:region) }
  let(:user) { create(:user, region_id: region.id) }
  let(:alert) { create(:alert, user_id: user.id) }

  context 'for unauthenticated user' do

    describe 'POST#create' do
      it 'denies access with 401 status code' do
        post :create, id: alert
        expect(response).not_to be_success
        expect(response).to have_http_status(401)
      end
    end
  end

  context 'user is authenticated' do

    let(:app) { create_client_app }
    let(:token) { access_token(app, user) }
    let(:alert_params) { FactoryGirl.attributes_for(:alert) }
    let(:wrong_alert) { FactoryGirl.attributes_for(:alert, alert_type: 'BAD') }

    describe 'POST#create' do
      it 'renders OK response' do
        post :create, alert: alert_params, access_token: token.token
        expect(Alert.first.user_id).to eq(user.id)
        expect(response).to be_success
        expect(response).to have_http_status(201)
      end

      it 'renders 422 for wrong params' do
        post :create, alert: wrong_alert, access_token: token.token
        expect(Alert.count).to eq(0)
        expect(response).not_to be_success
        expect(response).to have_http_status(422)
      end
    end

    describe 'GET#index' do
      let(:second_region) { create(:region) }
      let(:second_user) do
        create(:user, region_id: second_region.id, email: 'another@email.com')
      end
      let(:second_token) { access_token(app, second_user) }
      let(:alert_params) { FactoryGirl.attributes_for(:alert) }

      it 'renders OK response' do
        post :create, alert: alert_params, access_token: token.token
        get :index
        expect(response).to be_success
        expect(JSON.parse(response.body)['alerts'].count).to eq(1)
        expect(response).to have_http_status(200)
      end

      it 'renders only region specific alerts' do
        post :create, alert: alert_params, access_token: token.token
        post :create, alert: alert_params, access_token: second_token.token
        get :index
        expect(JSON.parse(response.body)['alerts'].count).to eq(1)
      end
    end
  end
end
