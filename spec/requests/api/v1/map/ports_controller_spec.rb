require 'spec_helper'

describe V1::Map::PortsController, type: :controller do

  let!(:port) { create(:port) }
  let(:yacht) { create(:yacht) }
  let(:user) { create(:user, yacht: yacht) }
  let(:user_without_yacht) { create(:user, email: 'b@test.com') }
  let(:app) { create_client_app }
  let(:token) { access_token(app, user) }
  let(:token2) { access_token(app, user_without_yacht) }

  describe 'GET#calculate' do
    context 'is logged in' do
      before do
        controller.stub(:doorkeeper_token) { token }
        get :calculate, id: port
      end

      it_behaves_like 'a successful request'

      it 'includes cost' do
        expect(json.port.cost).not_to eq(nil)
      end

      context 'has no yacht' do
        before do
          controller.stub(:doorkeeper_token) { token2 }
          get :calculate, id: port
        end

        it_behaves_like 'a not successful request'

        it 'sets nil as cost' do
          expect(json.port.cost).to eq(nil)
        end

        it 'responds with (465) no yacht present' do
          expect(response.status).to eq(465)
        end
      end
    end

    context 'is logged out' do
      before { get :calculate, id: port }
      it_behaves_like 'an unauthorized request'
    end
  end
end
