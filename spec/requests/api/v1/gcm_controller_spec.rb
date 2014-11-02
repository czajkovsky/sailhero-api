require 'spec_helper'

describe V1::GcmController, type: :controller do

  let(:user) { create(:user) }
  let(:gcm) { create(:gcm) }

  context 'for unauthenticated user' do

    describe 'POST#create' do
      it 'denies access with 401 status code' do
        post :create, id: gcm
        expect(response).not_to be_success
        expect(response).to have_http_status(401)
      end
    end
  end

  context 'user is authenticated' do

    let(:app) { create_client_app }
    let(:token) { access_token(app, user) }
    let(:gcm_params) { FactoryGirl.attributes_for(:gcm) }

    describe 'POST#create' do
      it 'renders CREATED response' do
        post :create, gcm: gcm_params, access_token: token.token
        expect(Gcm.first.token_id).to eq(token.id)
        expect(Gcm.first.key).to eq(gcm_params[:key])
        expect(response).to be_success
        expect(response).to have_http_status(201)
      end
    end
  end
end
