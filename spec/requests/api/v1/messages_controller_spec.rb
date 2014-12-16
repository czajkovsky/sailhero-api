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
    let(:message) { create(:message, region: region, user: user) }
    let(:region2) { create(:region) }
    let(:user2) { create(:user, region: region2, email: 'b@test.com') }
    let(:token2) { access_token(app, user2) }

    describe 'POST#create' do
      context 'has valid token' do
        before do
          post :create, access_token: token.token, message: message_params
        end
        it_behaves_like 'a successful create'

        it 'includes current user id in response' do
          expect(json.message.user_id).to eq(user.id)
        end

        it 'creates message' do
          expect(Message.last.body).to eq(message_params[:body])
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

      context 'with shared position' do
        before do
          controller.stub(:doorkeeper_token) { token }
          request.env['HTTP_LONGITUDE'] = 10.0
          request.env['HTTP_LATITUDE'] = 12.0
          post :create, message: message_params
        end

        it_behaves_like 'a successful create'

        it 'saves latitude and longitude' do
          expect(json.message.latitude).to eq(12.0.to_s)
          expect(json.message.longitude).to eq(10.0.to_s)
        end
      end
    end

    describe 'GET#show' do
      context 'same region' do
        before { get :show, id: message, access_token: token.token }
        it_behaves_like 'a successful request'

        it 'includes message in response' do
          expect(json.message.id).to eq(message.id)
        end
      end

      context 'different region' do
        before { get :show, id: message, access_token: token2.token }

        it_behaves_like 'a not successful request'

        it 'responds with (460) no region selected code' do
          expect(response.status).to eq(460)
        end
      end
    end

    describe 'GET#index' do
      let!(:m1) { create(:message, region: region, user: user, body: 'm1') }
      let!(:m2) { create(:message, region: region, user: user, body: 'm2') }
      let!(:m3) { create(:message, region: region2, user: user, body: 'm3') }
      let!(:m4) { create(:message, region: region, user: user, body: 'm4') }

      before { get :index, access_token: token.token }

      it_behaves_like 'a successful request'

      it 'includes only region messages' do
        expect(json.messages.count).to eq(3)
      end

      context 'has changed per param' do
        before { get :index, page: 2, per: 1, access_token: token.token }

        it_behaves_like 'a successful request'

        it 'includes proper messages count' do
          expect(json.messages.count).to eq(1)
        end

        it 'includes proper message' do
          expect(json.messages.first.body).to eq(m2.body)
        end
      end
    end
  end
end