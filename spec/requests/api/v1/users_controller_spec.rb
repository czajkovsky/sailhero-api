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

    describe 'GET#index' do
      let!(:user2) { create(:user, user_params('Eve', 'Grey', 'eve@g.com')) }
      let!(:user3) { create(:user, user_params('Tom', 'Pink', 'pink@t.com')) }
      let!(:user4) { create(:user, user_params('Tom', 'Red', 'blue@test.com')) }

      it 'searches multiple users' do
        get :index, q: 'tom', access_token: token.token
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)['users'].count).to eq(2)
      end

      it 'return empty array when there are no users' do
        get :index, q: 'tomisnotthename', access_token: token.token
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)['users'].count).to eq(0)
      end
    end

    describe 'DELETE#me' do
      it 'renders OK response' do
        delete :deactivate_profile, access_token: token.token
        token.reload
        user.reload
        expect(user.active).to eq(false)
        expect(token.revoked?).to eq(true)
        expect(response).to have_http_status(200)
      end
    end

    describe 'PUT#update' do
      it 'updates user' do
        controller.stub(:doorkeeper_token) { token }
        put :update, id: user, user: { name: 'Tom' }
        user.reload
        expect(user.name).to eq('Tom')
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
