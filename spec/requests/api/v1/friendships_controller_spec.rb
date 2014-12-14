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

        it 'includes friend in response' do
          expect(json.friendship.friend.email).to eq(friend.email)
        end
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
      context 'gets list of all friends' do
        before do
          controller.stub(:doorkeeper_token) { friend_token }
          post :create, friend_id: user.id, friendship: { friend_id: user.id }
          controller.stub(:doorkeeper_token) { token }
          get :index
        end

        it_behaves_like 'a successful request'

        it 'includes sent invites' do
          expect(json.sent.count).to eq(0)
        end

        it 'includes pending invites' do
          expect(json.pending.count).to eq(1)
        end

        it 'includes accepted invites' do
          expect(json.accepted.count).to eq(0)
        end
      end
    end

    describe 'POST#cancel' do
      let(:friendship) do
        create(:friendship, user_id: user.id, friend_id: friend.id)
      end
      let(:third_user) { create(:user, email: 't3@example.com') }
      let(:third_token) { access_token(app, third_user) }

      context 'cancels friendship' do
        before do
          controller.stub(:doorkeeper_token) { token }
          post :cancel, id: friendship
        end

        it_behaves_like 'a successful request'

        it 'removes friendship' do
          expect(Friendship.count).to eq(0)
        end
      end

      context 'not an owner tries to cancel' do
        before do
          controller.stub(:doorkeeper_token) { third_token }
          post :cancel, id: friendship
        end

        it_behaves_like 'a forbidden request'

        it "doesn't remove friendship" do
          expect(Friendship.count).to eq(1)
        end
      end
    end

    describe 'GET#show' do
      let(:friendship) do
        create(:friendship, user_id: user.id, friend_id: friend.id)
      end

      context 'gets friendship' do
        before do
          controller.stub(:doorkeeper_token) { token }
          get :show, id: friendship
        end

        it_behaves_like 'a successful request'

        it 'responds with correct friend' do
          expect(json.friendship.friend.email).to eq(friend.email)
        end

        it 'sets user as inviter' do
          expect(json.friendship.invited).to eq(false)
        end

      end
    end

    describe 'POST#deny' do
      let(:friendship) do
        create(:friendship, user_id: user.id, friend_id: friend.id)
      end

      context 'inviter tries to deny' do
        before do
          controller.stub(:doorkeeper_token) { token }
          post :deny, id: friendship
        end

        it_behaves_like 'a forbidden request'

        it "doesn't change friendships count" do
          expect(user.friendships.count).to eq(1)
        end
      end

      context 'invited denies friendship' do
        before do
          controller.stub(:doorkeeper_token) { friend_token }
          post :deny, id: friendship
        end

        it_behaves_like 'a successful request'

        it 'removes friendship' do
          expect(user.friendships.count).to eq(0)
        end
      end

      it "doesn't include friendship in any list" do
        controller.stub(:doorkeeper_token) { friend_token }
        post :accept, id: friendship
        get :pending
        expect(json.friendships.count).to eq(0)
        get :accepted
        expect(json.friendships.count).to eq(1)
        controller.stub(:doorkeeper_token) { token }
        get :sent
        expect(json.friendships.count).to eq(0)
        get :accepted
        expect(json.friendships.count).to eq(1)
      end
    end

    describe 'POST#accept' do
      let(:friendship) do
        create(:friendship, user_id: user.id, friend_id: friend.id)
      end

      context 'user is not authorized' do
        before do
          controller.stub(:doorkeeper_token) { token }
          post :accept, id: friendship
          friendship.reload
        end

        it_behaves_like 'a forbidden request'

        it 'still includes friendship' do
          expect(user.friendships.count).to eq(1)
        end

        it 'keeps friendship as pending' do
          expect(friendship.pending?).to eq(true)
        end

        it "doesn't mark friendship as accepted" do
          expect(friendship.accepted?).to eq(false)
        end
      end

      context 'user is authorized' do
        before(:each) do
          controller.stub(:doorkeeper_token) { friend_token }
          post :accept, id: friendship
          friendship.reload
        end

        it_behaves_like 'a successful request'

        it 'marks friendship as accepted' do
          expect(friendship.accepted?).to eq(true)
        end

        it 'responds with friendship data' do
          expect(json.friendship.friend.id).to eq(user.id)
        end

        context 'when checks accepted' do
          before(:each) { get :accepted }

          it_behaves_like 'a successful request'

          it 'includes user as friend' do
            expect(json.friendships.first.friend.id).to eq(user.id)
          end

          it 'responds with proper list of friendships' do
            expect(json.friendships.count).to eq(1)
          end
        end

        context 'when users checks same list' do
          before(:each) do
            controller.stub(:doorkeeper_token) { token }
            get :accepted
          end

          it_behaves_like 'a successful request'

          it 'includes user as friend' do
            expect(json.friendships.first.friend.id).to eq(friend.id)
          end

          it 'responds with proper list of friendships' do
            expect(json.friendships.count).to eq(1)
          end
        end
      end
    end
  end
end
