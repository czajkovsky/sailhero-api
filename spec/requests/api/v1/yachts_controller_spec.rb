require 'spec_helper'

describe V1::YachtsController, type: :controller do

  let(:yachtA_params) { FactoryGirl.attributes_for(:yacht) }
  let(:yachtB_params) { FactoryGirl.attributes_for(:yacht, name: 'Another') }

  context 'for unauthenticated user' do

    describe 'POST#create' do
      it 'denies access with 401 status code' do
        post :create, yacht: yachtA_params
        expect(response).not_to be_success
        expect(response).to have_http_status(401)
      end
    end
  end

  context 'user is authenticated' do

    let(:app) { create_client_app }
    let(:user) { create(:user) }
    let(:token) { access_token(app, user) }

    describe 'POST#create' do
      it 'creates yacht' do
        post :create, yacht: yachtA_params, access_token: token.token
        expect(response).to have_http_status(201)
        expect(user.yacht.name).to eq(yachtA_params[:name])
      end

      context 'user has already created yacht' do
        it "doesn't create second yacht" do
          post :create, yacht: yachtA_params, access_token: token.token
          post :create, yacht: yachtB_params, access_token: token.token
          expect(response).to have_http_status(422)
          expect(user.yacht.name).to eq(yachtA_params[:name])
          expect(Yacht.count).to eq(1)
        end
      end
    end

    describe 'PUT#update' do
      let (:yacht) { create(:yacht, user_id: user.id) }

      it 'updates yacht' do
        user.yacht = yacht
        put :update, id: yacht, yacht: yachtB_params, access_token: token.token
        expect(response).to have_http_status(200)
        expect(response.body).to include(yachtB_params[:name])
      end

      it 'returns error for wrong yacht params' do
        wrong_params = FactoryGirl.attributes_for(:yacht, length: 500_000)
        put :update, id: yacht, yacht: wrong_params, access_token: token.token
        expect(response).to have_http_status(422)
      end

      context 'yacht belongs to another user' do
        it 'forbids access with 403 status' do
          yacht2 = FactoryGirl.create(:yacht, user_id: 10)
          put :update, id: yacht2, yacht: yachtA_params,
                       access_token: token.token
          expect(response).to have_http_status(403)
        end
      end
    end
  end
end
