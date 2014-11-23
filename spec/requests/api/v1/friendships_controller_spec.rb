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

    describe 'POST#create' do
      it 'renders OK response' do
        post :create, friend_id: friend.id, access_token: token.token,
                      friendship: { friend_id: friend.id }
        expect(response).to be_success
        expect(response).to have_http_status(201)
      end
    end
  end
end
