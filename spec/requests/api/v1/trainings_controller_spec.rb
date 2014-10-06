require 'spec_helper'

describe V1::TrainingsController, type: :controller do

  let(:region) { create(:region) }
  let(:user) { create(:user, region_id: region.id) }
  let(:user_without_region) { create(:user) }

  context 'for unauthenticated user' do

    describe 'GET#index' do
      it 'denies access with 401 status code' do
        get :index
        expect(response).not_to be_success
        expect(response).to have_http_status(401)
      end
    end

    describe 'POST#create' do
      it 'denies access with 401 status code' do
        post :create
        expect(response).not_to be_success
        expect(response).to have_http_status(401)
      end
    end
  end

  context 'user is authenticated' do

    let(:app) { create_client_app }
    let(:token) { access_token(app, user) }
    let(:token2) { access_token(app, user_without_region) }

    context 'has no region' do
      it 'renders 460 no region response' do
        get :index, access_token: token2.token
        expect(response).not_to be_success
        expect(response).to have_http_status(460)
      end
    end

    context 'has valid region' do

      describe 'GET#index' do
        it 'renders 200' do
          get :index, access_token: token.token
          expect(response).to be_success
          expect(response).to have_http_status(200)
        end
      end

      describe 'POST#create' do
        context 'has no started trainings' do
          it 'renders 201 created' do
            post :create, access_token: token.token
            expect(response).to be_success
            expect(user.trainings.not_finished.count).to eq(1)
            expect(response).to have_http_status(201)
          end
        end

        context 'already started training' do
          it 'renders 201 created' do
            post :create, access_token: token.token
            post :create, access_token: token.token
            expect(response).to_not be_success
            expect(user.trainings.not_finished.count).to eq(1)
            expect(response).to have_http_status(422)
          end
        end
      end
    end
  end
end
