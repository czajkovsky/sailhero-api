require 'spec_helper'

describe V1::Map::PortsController, type: :controller do

  let(:region) { create(:region) }
  let(:region2) { create(:region, code_name: 'ACR') }
  let!(:port) { create(:port, region: region) }
  let!(:port_in_different_region) { create(:port, region: region2) }
  let(:user) { create(:user, region: region) }
  let(:user_without_yacht) { create(:user, email: 'b@t.com', region: region) }
  let!(:yacht) { create(:yacht, user: user) }
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

  describe 'GET#show' do
    context 'same region' do
      before do
        controller.stub(:doorkeeper_token) { token }
        get :show, id: port
      end

      it_behaves_like 'a successful request'

      it 'includes port' do
        expect(json.port.id).to eq(port.id)
      end
    end

    context 'has different region' do
      before do
        controller.stub(:doorkeeper_token) { token }
        get :show, id: port_in_different_region
      end

      it_behaves_like 'a not found request'
    end
  end

  describe 'GET#index' do
    before do
      controller.stub(:doorkeeper_token) { token }
      get :index
    end

    it_behaves_like 'a successful request'

    it 'includes ports' do
      expect(json.ports.count).to eq(1)
    end
  end
end
