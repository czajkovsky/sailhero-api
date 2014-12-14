require 'spec_helper'

describe V1::DevicesController, type: :controller do

  let(:user) { create(:user) }
  let(:device_params) { FactoryGirl.attributes_for(:device) }
  let(:wrong_device_params) do
    FactoryGirl.attributes_for(:device, device_type: 'WRONG')
  end

  context 'for unauthenticated user' do
    describe 'POST#create' do
      before { post :create, id: device_params }
      it_behaves_like 'an unauthorized request'
    end
  end

  context 'user is authenticated' do
    let(:app) { create_client_app }
    let(:token) { access_token(app, user) }
    let(:token2) { access_token(app, user) }

    describe 'POST#create' do
      context 'has valid params' do
        before do
          controller.stub(:doorkeeper_token) { token }
          post :create, device: device_params
        end

        it_behaves_like 'a successful create'

        it 'connects device with user' do
          expect(Device.first.user_id).to eq(user.id)
        end

        it 'connects device with token' do
          expect(Device.first.token_id).to eq(token.id)
        end

        context 'overrides device' do
          before do
            controller.stub(:doorkeeper_token) { token2 }
            post :create, device: device_params
          end

          it_behaves_like 'a successful create'

          it 'overrides token' do
            expect(Device.first.token_id).to eq(token2.id)
          end

          it 'overrides user' do
            expect(Device.first.user_id).to eq(user.id)
          end

          it 'responds with new token' do
            expect(json.device.id).to eq(Device.first.id)
          end
        end
      end

      context 'tries to set invalid device' do
        before do
          controller.stub(:doorkeeper_token) { token }
          post :create, device: wrong_device_params
        end

        it_behaves_like 'a failed create/update'
      end
    end
  end
end
