require 'spec_helper'

describe V1::MessagesController, type: :controller do
  context 'when logged out' do
    describe 'GET#index' do
      before { get :index }
      it_behaves_like 'an unauthorized request'
    end
  end

  context 'when logged in' do
    let(:app) { create_client_app }
    let(:region) { create(:region) }
    let(:user) { create(:user, region: region) }
    let(:user_without_region) { create(:user, email: 'an@test.com') }
    let(:token) { access_token(app, user) }
    let(:token_without_region) { access_token(app, user_without_region) }
    let(:message_params) { FactoryGirl.attributes_for(:message) }

    describe 'POST#create' do
      context 'has valid token' do
        before do
          post :create, access_token: token.token, message: message_params
        end
        it_behaves_like 'a successful create'

        it 'includes current user id in response' do
          expect(json.message.user_id).to eq(user.id)
        end
      end

      context 'user without region' do
        before do
          controller.stub(:doorkeeper_token) { token_without_region }
          post :create, message: message_params
        end

        it_behaves_like 'a not successful request'

        it 'responds with (460) no region selected code' do
          expect(response.status).to eq(460)
        end
      end
    end
  end
end
