require 'spec_helper'

describe V1::FriendshipsController, type: :controller do

  let(:user) { create(:user) }
  let(:friend) { create(:user, email: 'another@email.com') }

  context 'for unauthenticated user' do
    describe 'POST#create' do
      before { post :create, friend_id: friend.id }
      it_behaves_like 'an unauthorized request'
    end
  end

  context 'user is authenticated' do
    let(:app) { create_client_app }
    let(:token) { access_token(app, user) }
    let(:friend_token) { access_token(app, friend) }

    describe 'POST#create' do
      context 'sends valid params' do
        before do
          post :create, friend_id: friend.id, access_token: token.token,
                        friendship: { friend_id: friend.id }
        end
        it_behaves_like 'a successful create'
      end

      context 'is forever alone' do
        before do
          post :create, friend_id: user.id, access_token: token.token,
                        friendship: { friend_id: user.id }
        end
        it_behaves_like 'a not successful request'

        it 'responds with 462 status code' do
          expect(response).to have_http_status(462)
        end
      end

      context 'friend does not exist' do
        before do
          post :create, friend_id: 1000, access_token: token.token,
                        friendship: { friend_id: 1000 }
        end

        it_behaves_like 'a not successful request'

        it 'responds with 463 status code' do
          expect(response).to have_http_status(463)
        end
      end

      context 'tries to duplicate friends' do
        before do
          post :create, friend_id: friend.id, access_token: token.token,
                        friendship: { friend_id: friend.id }
          post :create, friend_id: friend.id, access_token: token.token,
                        friendship: { friend_id: friend.id }
        end

        it_behaves_like 'a forbidden request'
      end

      context 'tries to duplicate inv friends' do
        before do
          controller.stub(:doorkeeper_token) { token }
          post :create, friend_id: friend.id,
                        friendship: { friend_id: friend.id }
          controller.stub(:doorkeeper_token) { friend_token }
          post :create, friend_id: user.id, friendship: { friend_id: user.id }
        end

        it_behaves_like 'a forbidden request'
      end
    end

    describe 'GET#accepted' do
      context 'has some sent invites' do
        before do
          post :create, friend_id: friend.id, access_token: token.token,
                        friendship: { friend_id: friend.id }
          get :accepted, access_token: token.token
        end

        it_behaves_like 'a successful request'

        it 'does not include sent in friendships' do
          expect(json.friendships.count).to eq(0)
        end
      end

      context 'has pending invites' do
        before do
          controller.stub(:doorkeeper_token) { friend_token }
          post :create, friend_id: user.id, friendship: { friend_id: user.id }
          get :accepted, access_token: token.token
        end

        it_behaves_like 'a successful request'

        it 'does not include pending in friendships' do
          expect(json.friendships.count).to eq(0)
        end
      end
    end

    describe 'GET#sent' do
      context 'has sent invites' do
        before do
          post :create, friend_id: friend.id, access_token: token.token,
                        friendship: { friend_id: friend.id }
          get :sent, access_token: token.token
        end

        it_behaves_like 'a successful request'

        it 'responds with sent invites' do
          expect(json.friendships.count).to eq(1)
        end
      end
    end

    describe 'GET#pending' do
      context 'sent are pending for friend' do
        before do
          controller.stub(:doorkeeper_token) { friend_token }
          post :create, friend_id: user.id, friendship: { friend_id: user.id }
          controller.stub(:doorkeeper_token) { token }
          get :pending
        end

        it_behaves_like 'a successful request'

        it 'includes invite in list' do
          expect(json.friendships.count).to eq(1)
        end
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
