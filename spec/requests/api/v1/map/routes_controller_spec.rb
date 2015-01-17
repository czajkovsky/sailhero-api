require 'spec_helper'

describe V1::Map::RoutesController, type: :controller do

  let(:region1) { create(:region) }
  let(:region2) { create(:region, code_name: 'ACR') }

  let(:user) { create(:user, region_id: region1.id) }
  let(:user2) { create(:user, email: 'b@test.com') }
  let(:app) { create_client_app }
  let(:token) { access_token(app, user) }
  let(:token2) { access_token(app, user2) }

  let!(:route1) { create(:route, region_id: region1.id) }
  let!(:route2) { create(:route, region_id: region2.id) }

  let!(:pin1) { create(:pin, route_id: region1.id) }
  let!(:pin2) { create(:pin, route_id: region1.id) }
  let!(:pin3) { create(:pin, route_id: region2.id) }

  describe 'GET#index' do
    context 'is logged in' do
      before { get :index, access_token: token.token }
      it_behaves_like 'a successful request'

      it 'includes only region specific routes' do
        expect(json.routes.count).to eq(1)
      end

      it 'includes pins' do
        expect(json.routes.first.pins.count).to eq(2)
      end

      context 'has no region selected' do
        before do
          controller.stub(:doorkeeper_token) { token2 }
          get :index
        end

        it_behaves_like 'a not successful request'

        it 'responds with (460) no region selected code' do
          expect(response.status).to eq(460)
        end
      end
    end

    context 'is logged out' do
      before { get :index }
      it_behaves_like 'an unauthorized request'
    end
  end

  describe 'GET#show' do
    context 'same region for route and user' do
      before do
        controller.stub(:doorkeeper_token) { token }
        get :show, id: route1
      end

      it_behaves_like 'a successful request'

      it 'responds with region' do
        expect(json.route.id).to eq(route1.id)
      end

      it 'includes pins' do
        expect(json.route.pins.count).to eq(2)
      end
    end

    context 'different region for route and user' do
      before do
        controller.stub(:doorkeeper_token) { token }
        get :show, id: route2
      end

      it_behaves_like 'a not found request'
    end
  end
end
