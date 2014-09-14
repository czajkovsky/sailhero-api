require 'spec_helper'

describe V1::UsersController, type: :controller do

  context 'for unauthenticated user' do

    describe 'GET#me' do
      it 'denies access with 401 status code' do
        get :me
        expect(response).not_to be_success
        expect(response).to have_http_status(401)
      end
    end
  end

  context 'user is authenticated' do

    let(:token) { stub accessible?: true }

    before do
      controller.stub(:doorkeeper_token) { token }
    end

    describe 'GET#me' do
      it 'renders OK response' do
        expect(response).to have_http_status(200)
      end
    end
  end
end
