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

    describe 'GET#index' do
      it "doesn't include sent requests" do
        post :create, friend_id: friend.id, access_token: token.token,
                      friendship: { friend_id: friend.id }
        get :index, access_token: token.token
        expect(response).to be_success
        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)['friendships'].count).to eq(0)
      end

      it "doesn't include pending requests" do
        controller.stub(:doorkeeper_token) { friend_token }
        post :create, friend_id: user.id, friendship: { friend_id: user.id }
        get :index, access_token: token.token
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

    describe 'GET#show' do
      let(:friendship) do
        create(:friendship, user_id: user.id, friend_id: friend.id)
      end

      it 'responds with friendship' do
        controller.stub(:doorkeeper_token) { token }
        get :show, id: friendship
        expect(response).to have_http_status(200)
        body = JSON.parse(response.body)['friendship']
        expect(body['user']['id']).to eq(user.id)
        expect(body['friend']['id']).to eq(friend.id)
      end
    end

    describe 'POST#deny' do
      let(:friendship) do
        create(:friendship, user_id: user.id, friend_id: friend.id)
      end

      it 'denies friendship' do
        controller.stub(:doorkeeper_token) { token }
        put :deny, id: friendship
        expect(response).to have_http_status(200)
        expect(user.friendships.count).to eq(0)
      end
    end
  end
end
