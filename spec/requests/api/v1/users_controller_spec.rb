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

        it 'includes extended data in response' do
          expect(json.user.created_at).not_to eq(nil)
          expect(json.user.share_position).not_to eq(nil)
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
      let!(:user3) do
        create(:user, user_params('Tom', 'Pink', 'pink@t.com', false))
      end
      let!(:user4) { create(:user, user_params('Tom', 'Red', 'blue@test.com')) }

      context 'search has results' do
        before { get :index, q: 'tom', access_token: token.token }
        it_behaves_like 'a successful request'
        it 'responds only with active users' do
          expect(json.users.count).to eq(1)
        end

        it "doesn't includes extended data in response" do
          expect(json.users.first.created_at).to eq(nil)
        end
      end

      context 'substring search' do
        before { get :index, q: 'blue', access_token: token.token }

        it_behaves_like 'a successful request'

        it 'responds with users' do
          expect(json.users.count).to eq(1)
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

      context 'user tries to change email' do
        before do
          controller.stub(:doorkeeper_token) { token }
          put :update, id: user, user: { email: 'b@test.com' }
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

    context 'submits valid params' do
      before { post :create, user: user_params }

      it 'creates user' do
        expect(User.last.email).to eq(user_params[:email])
      end

      it 'user has not active' do
        expect(User.last.active).to eq(false)
      end

      it 'responds with user data' do
        expect(json.user.email).to eq(user_params[:email])
      end

      it 'sets null for avatar as default' do
        expect(json.user.avatar).to eq(nil)
      end

      it_behaves_like 'a successful create'
    end

    context "doesn't submit passowrd" do
      before { post :create, user: without_pass }

      it_behaves_like 'a failed create/update'

      it "doesn't create user" do
        expect(User.count).to eq(0)
      end
    end

    context 'creates user with avatar' do
      let(:with_avatar_params) { FactoryGirl.attributes_for(:user_with_avatar) }
      before { post :create, user: with_avatar_params }

      it_behaves_like 'a successful create'

      it 'responds with avatar url' do
        expect(json.user.avatar_url).not_to eq(nil)
      end
    end

    context 'submits wrong params' do
      before { post :create, user: wrong_user_params }

      it_behaves_like 'a failed create/update'

      it "doesn't create user" do
        expect(User.count).to eq(0)
      end
    end
  end
end
