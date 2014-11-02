require 'spec_helper'

describe V1::DevicesController, type: :controller do

  let(:user) { create(:user) }
  let(:device_params) { FactoryGirl.attributes_for(:device) }

  context 'for unauthenticated user' do

    describe 'POST#create' do
      it 'denies access with 401 status code' do
        post :create, id: device_params
        expect(response).not_to be_success
        expect(response).to have_http_status(401)
      end
    end
  end

  context 'user is authenticated' do

    let(:app) { create_client_app }
    let(:token) { access_token(app, user) }

    describe 'POST#create' do
      it 'renders OK response' do
        post :create, device: device_params, access_token: token.token
        device = Device.first
        expect(device.user_id).to eq(user.id)
        expect(device.token_id).to eq(token.id)
        expect(response).to be_success
        expect(response).to have_http_status(201)
      end
    end
  end
end
