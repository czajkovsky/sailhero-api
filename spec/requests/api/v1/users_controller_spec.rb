require 'spec_helper'

describe V1::UsersController, type: :controller do

  context 'when logged out' do
    describe 'GET#me' do
      before { get :me }
      it_behaves_like 'an unauthorized request'
    end
  end

  context 'when logged in' do

    let(:app) { create_client_app }
    let(:user) { create(:user) }
    let(:token) { access_token(app, user) }

    describe 'GET#me' do
      context 'has valid token' do
        before { get :me, access_token: token.token }
        it_behaves_like 'a successful request'

        it 'includes email in response' do
          expect(json.user.email).to eq(user.email)
        end
      end

      context 'token is revoked' do
        before do
          token.revoke
          get :me, access_token: token.token
        end

        it_behaves_like 'an unauthorized request'
      end
    end

    describe 'GET#index' do
      let!(:user2) { create(:user, user_params('Eve', 'Grey', 'eve@g.com')) }
      let!(:user3) { create(:user, user_params('Tom', 'Pink', 'pink@t.com')) }
      let!(:user4) { create(:user, user_params('Tom', 'Red', 'blue@test.com')) }

      context 'search has results' do
        before { get :index, q: 'tom', access_token: token.token }
        it_behaves_like 'a successful request'
        it 'responds with users' do
          expect(json.users.count).to eq(2)
        end
      end

      context 'search has no results' do
        before { get :index, q: 'tomisnotthename', access_token: token.token }
        it_behaves_like 'a successful request'
        it 'responds with users' do
          expect(json.users.count).to eq(0)
        end
      end
    end

    describe 'DELETE#me' do
      before { delete :deactivate_profile, access_token: token.token }

      it 'revokes token' do
        token.reload
        expect(token.revoked?).to eq(true)
      end

      it 'deactivates user' do
        user.reload
        expect(user.active).to eq(false)
      end

      it_behaves_like 'a successful request'
    end

    describe 'PUT#update' do
      let(:user2) { create(:user, user_params('Eve', 'Grey', 'eve@g.com')) }
      let(:token2) { access_token(app, user2) }

      context 'user tries to change profile with valid data' do
        before do
          controller.stub(:doorkeeper_token) { token }
          put :update, id: user, user: { name: 'Tom' }
        end

        it_behaves_like 'a successful request'

        it 'updates user data' do
          user.reload
          expect(user.name).to eq('Tom')
        end

        it 'includes updated data in response' do
          expect(json.user.name).to eq('Tom')
        end
      end

      context 'user tries to change profile with invalid data' do
        before do
          controller.stub(:doorkeeper_token) { token }
          params = { password: 'P@ssw0rd1', password_confirmation: 'P@ssw0rd2' }
          put :update, id: user, user: params
        end

        it_behaves_like 'a failed create/update'
      end

      context 'invalid users tries to change data' do
        before do
          controller.stub(:doorkeeper_token) { token2 }
          put :update, id: user, user: { name: 'Tom' }
        end

        it_behaves_like 'a forbidden request'
      end
    end
  end

  describe 'POST#create' do
    let(:user_params) { FactoryGirl.attributes_for(:user) }
    let(:wrong_user_params) do
      FactoryGirl.attributes_for(:user, email: 'wrong@te')
    end
    let(:without_pass) do
      FactoryGirl.attributes_for(:user, password: '', password_confirmation: '')
    end

    it 'creates user with 201 status' do
      post :create, user: user_params
      expect(response).to have_http_status(201)
      expect(User.last.email).to eq(user_params[:email])
    end

    it 'requires password' do
      post :create, user: without_pass
      expect(response).to have_http_status(422)
      expect(User.count).to eq(0)
    end

    it 'sets null for avatar as default' do
      post :create, user: user_params
      expect(json.user.avatar).to eq(nil)
    end

    it 'does not create user because of wrong params' do
      post :create, user: wrong_user_params
      expect(response).to have_http_status(422)
      expect(User.count).to eq(0)
    end
  end
end
