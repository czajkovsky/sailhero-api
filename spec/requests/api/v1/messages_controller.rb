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
    let(:token) { access_token(app, user) }
    let(:message_params) { FactoryGirl.attributes_for(:message) }

    describe 'POST#create' do
      context 'has valid token' do
        before do
          post :create, access_token: token.token, message: message_params
        end
        it_behaves_like 'a successful request'

        it 'includes current user id in response' do
          expect(json.message.user_id).to eq(user.id)
        end
      end
    end
  end
end
