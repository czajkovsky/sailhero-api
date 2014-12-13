require 'spec_helper'

describe V1::FriendshipsController, type: :controller do

  let(:user) { create(:user) }
  let(:friend) { create(:user, email: 'another@email.com') }

  context 'for unauthenticated user' do

    describe 'POST#create' do
      it 'denies access with 401 status code' do
        post :create, friend_id: friend.id
        expect(response).not_to be_success
        expect(response).to have_http_status(401)
      end
    end
  end

  context 'user is authenticated' do

    let(:app) { create_client_app }
    let(:token) { access_token(app, user) }
    let(:friend_token) { access_token(app, friend) }

    describe 'POST#create' do
      it 'renders OK response' do
        post :create, friend_id: friend.id, access_token: token.token,
                      friendship: { friend_id: friend.id }
        expect(response).to be_success
        expect(response).to have_http_status(201)
      end

      it 'prevents self friending' do
        post :create, friend_id: user.id, access_token: token.token,
                      friendship: { friend_id: user.id }
        expect(response).not_to be_success
        expect(response).to have_http_status(462)
      end

      it 'checks if friend exists' do
        post :create, friend_id: 1000, access_token: token.token,
                      friendship: { friend_id: 1000 }
        expect(response).not_to be_success
        expect(response).to have_http_status(463)
      end

      it "doesn't duplicate friendships" do
        post :create, friend_id: friend.id, access_token: token.token,
                      friendship: { friend_id: friend.id }
        post :create, friend_id: friend.id, access_token: token.token,
                      friendship: { friend_id: friend.id }
        expect(response).not_to be_success
        expect(response).to have_http_status(403)
      end

      it "doesn't duplicate inv friendships" do
        post :create, friend_id: friend.id, access_token: token.token,
                      friendship: { friend_id: friend.id }
        controller.stub(:doorkeeper_token) { friend_token }
        post :create, friend_id: user.id, friendship: { friend_id: user.id }
        expect(response).not_to be_success
        expect(response).to have_http_status(403)
      end
    end

    describe 'GET#accepted' do
      it "doesn't include sent requests" do
        post :create, friend_id: friend.id, access_token: token.token,
                      friendship: { friend_id: friend.id }
        get :accepted, access_token: token.token
        expect(response).to be_success
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)['friendships'].count).to eq(0)
      end

      it "doesn't include pending requests" do
        controller.stub(:doorkeeper_token) { friend_token }
        post :create, friend_id: user.id, friendship: { friend_id: user.id }
        get :accepted, access_token: token.token
        expect(response).to be_success
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)['friendships'].count).to eq(0)
      end
    end

    describe 'GET#sent' do
      it 'resonds with sent friendships' do
        post :create, friend_id: friend.id, access_token: token.token,
                      friendship: { friend_id: friend.id }
        get :sent, access_token: token.token
        expect(response).to be_success
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)['friendships'].count).to eq(1)
      end
    end

    describe 'GET#pending' do
      it 'resonds with sent friendships' do
        controller.stub(:doorkeeper_token) { friend_token }
        post :create, friend_id: user.id, friendship: { friend_id: user.id }
        controller.stub(:doorkeeper_token) { token }
        get :pending
        expect(response).to be_success
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)['friendships'].count).to eq(1)
      end
    end

    describe 'GET#index' do
      it 'resonds with all friendships' do
        controller.stub(:doorkeeper_token) { friend_token }
        post :create, friend_id: user.id, friendship: { friend_id: user.id }
        controller.stub(:doorkeeper_token) { token }
        get :index
        expect(response).to be_success
        expect(JSON.parse(response.body)['sent'].count).to eq(0)
        expect(JSON.parse(response.body)['accepted'].count).to eq(0)
        expect(JSON.parse(response.body)['pending'].count).to eq(1)
      end
    end

    describe 'POST#cancel' do
      let(:friendship) do
        create(:friendship, user_id: user.id, friend_id: friend.id)
      end
      let(:third_user) { create(:user, email: 't3@example.com') }
      let(:third_token) { access_token(app, third_user) }

      it 'cancels friendship' do
        controller.stub(:doorkeeper_token) { token }
        post :cancel, id: friendship
        expect(response).to have_http_status(200)
        expect(Friendship.count).to eq(0)
      end

      it 'only allows owners to destroy friendship' do
        controller.stub(:doorkeeper_token) { third_token }
        post :cancel, id: friendship
        expect(response).to have_http_status(403)
        expect(Friendship.count).to eq(1)
      end
    end

    describe 'GET#show' do
      let(:friendship) do
        create(:friendship, user_id: user.id, friend_id: friend.id)
      end

      it 'responds with friendship' do
        controller.stub(:doorkeeper_token) { token }
        get :show, id: friendship
        expect(response).to have_http_status(200)
        body = JSON.parse(response.body)['friendship']
        expect(body['friend']['id']).to eq(friend.id)
        expect(body['invited']).to eq(false)
      end
    end

    describe 'POST#deny' do
      let(:friendship) do
        create(:friendship, user_id: user.id, friend_id: friend.id)
      end

      it 'it denies access for user' do
        controller.stub(:doorkeeper_token) { token }
        post :deny, id: friendship
        expect(response).to have_http_status(403)
        expect(user.friendships.count).to eq(1)
      end

      it 'denies friendship' do
        controller.stub(:doorkeeper_token) { friend_token }
        post :deny, id: friendship
        expect(response).to have_http_status(200)
        expect(user.friendships.count).to eq(0)
      end

      it "doesn't include friendship in any list" do
        controller.stub(:doorkeeper_token) { friend_token }
        post :accept, id: friendship
        get :pending
        expect(JSON.parse(response.body)['friendships'].count).to eq(0)
        get :accepted
        expect(JSON.parse(response.body)['friendships'].count).to eq(1)
        controller.stub(:doorkeeper_token) { token }
        get :sent
        expect(JSON.parse(response.body)['friendships'].count).to eq(0)
        get :accepted
        expect(JSON.parse(response.body)['friendships'].count).to eq(1)
      end
    end

    describe 'POST#accept' do
      let(:friendship) do
        create(:friendship, user_id: user.id, friend_id: friend.id)
      end

      it 'it denies access for user' do
        controller.stub(:doorkeeper_token) { token }
        post :accept, id: friendship
        expect(response).to have_http_status(403)
        expect(user.friendships.count).to eq(1)
        friendship.reload
        expect(friendship.pending?).to eq(true)
        expect(friendship.accepted?).to eq(false)
      end

      it 'accepts friendship' do
        controller.stub(:doorkeeper_token) { friend_token }
        post :accept, id: friendship
        expect(response).to have_http_status(200)
        friendship.reload
        expect(friendship.accepted?).to eq(true)
        body = JSON.parse(response.body)['friendship']
        expect(body['friend']['id']).to eq(user.id)
      end

      it 'includes friendship in list for both users' do
        controller.stub(:doorkeeper_token) { friend_token }
        post :accept, id: friendship
        get :accepted
        body = JSON.parse(response.body)['friendships']
        expect(body[0]['friend']['id']).to eq(user.id)
        expect(body.count).to eq(1)
        controller.stub(:doorkeeper_token) { token }
        get :accepted
        body = JSON.parse(response.body)['friendships']
        expect(body.count).to eq(1)
        expect(body[0]['friend']['id']).to eq(friend.id)
      end
    end
  end
end
