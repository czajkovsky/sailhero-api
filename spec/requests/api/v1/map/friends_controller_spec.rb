require 'spec_helper'

describe V1::Map::FriendsController, type: :controller do

  let(:user) { create(:user) }
  let(:friend) { create(:user, email: 'c@test.com') }
  let(:shy_friend) do
    create(:user, share_position: false, email: 'd@test.com')
  end

  let!(:friendship1) { create_friendship(user, friend) }
  let!(:friendship2) { create_friendship(user, shy_friend) }

  let(:app) { create_client_app }
  let(:token) { access_token(app, user) }

  describe 'GET#index' do
    context 'is logged in' do
      before { get :index, access_token: token.token }
      it_behaves_like 'a successful request'

      it 'includes only active friends willing to share position' do
        expect(json.friends.count).to eq(1)
      end

      it 'includes lat and lng' do
        scope = json.friends.first.last_position
        expect(scope.latitude).to eq(friend.latitude.to_s)
        expect(scope.longitude).to eq(friend.longitude.to_s)
      end

      it "doesn't includes extended data in response" do
        expect(json.friends.first.created_at).to eq(nil)
      end
    end

    context 'is logged out' do
      before { get :index }
      it_behaves_like 'an unauthorized request'
    end
  end
end
