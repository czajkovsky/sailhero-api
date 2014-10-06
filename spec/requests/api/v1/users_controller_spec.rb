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

  context 'user is authenticated' do

    let(:app) { create_client_app }
    let(:user) { create(:user) }
    let(:token) { access_token(app, user) }

    describe 'GET#me' do
      it 'renders OK response' do
        get :me, access_token: token.token
        expect(response).to have_http_status(200)
        expect(response.body).to include(user.email)
      end

      context 'token is revoked' do
        it 'denies access with 401 status code' do
          token.revoke
          get :me, access_token: token.token
          expect(response).not_to be_success
          expect(response).to have_http_status(401)
        end
      end
    end
  end

  describe 'POST#create' do
    let(:user_params) { FactoryGirl.attributes_for(:user) }
    let(:wrong_user_params) do
      FactoryGirl.attributes_for(:user, email: 'wrong@te')
    end

    it 'creates user with 201 status' do
      post :create, user: user_params
      expect(response).to have_http_status(201)
      expect(User.last.email).to eq(user_params[:email])
    end

    it 'does not create user because of wrong params' do
      post :create, user: wrong_user_params
      expect(response).to have_http_status(422)
      expect(User.count).to eq(0)
    end
  end
end
