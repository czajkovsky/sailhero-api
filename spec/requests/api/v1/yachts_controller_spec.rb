require 'spec_helper'

describe V1::YachtsController, type: :controller do

  let(:yacht_params) { FactoryGirl.attributes_for(:yacht) }

  context 'for unauthenticated user' do

    describe 'POST#create' do
      it 'denies access with 401 status code' do
        post :create, yacht: yacht_params
        expect(response).not_to be_success
        expect(response).to have_http_status(401)
      end
    end
  end

  context 'user is authenticated' do

    let!(:app) { create_client_app }
    let!(:user) { create(:user) }
    let!(:token) { access_token(app, user) }

    describe 'POST#create' do
      it 'renders CREATED response' do
        post :create, yacht: yacht_params, access_token: token.token
        expect(user.yacht.name).to eq(yacht_params[:name])
        expect(response).to have_http_status(201)
      end
    end
  end
end
