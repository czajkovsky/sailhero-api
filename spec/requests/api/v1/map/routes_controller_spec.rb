require 'spec_helper'

describe V1::Map::RoutesController, type: :controller do

  let(:region1) { create(:region) }
  let(:region2) { create(:region) }
  let(:user) { create(:user, region_id: region1.id) }
  let(:user2) { create(:user, email: 'b@test.com') }
  let(:app) { create_client_app }
  let(:token) { access_token(app, user) }
  let(:token2) { access_token(app, user2) }
  let!(:route1) { create(:route, region_id: region1.id) }
  let!(:route2) { create(:route, region_id: region2.id) }

  describe 'GET#index' do
    context 'is logged in' do
      before { get :index, access_token: token.token }
      it_behaves_like 'a successful request'

      it 'includes only region specific routes' do
        expect(json.routes.count).to eq(1)
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
end
