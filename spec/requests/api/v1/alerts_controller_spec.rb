require 'spec_helper'

describe V1::AlertsController, type: :controller do

  let(:region) { create(:region) }
  let(:user) { create(:user, region_id: region.id) }
  let(:alert) { create(:alert, user_id: user.id, region_id: region.id) }

  context 'when not logged in' do
    describe 'POST#create' do
      before { post :create, id: alert }

      it_behaves_like 'an unauthorized request'
    end
  end

  context 'user is authenticated' do
    let(:app) { create_client_app }
    let(:token) { access_token(app, user) }
    let(:alert_params) { FactoryGirl.attributes_for(:alert) }
    let(:wrong_alert) { FactoryGirl.attributes_for(:alert, alert_type: 'BAD') }

    describe 'POST#create' do
      context 'sends valid params' do
        before { post :create, alert: alert_params, access_token: token.token }

        it_behaves_like 'a successful create'

        it 'responds with alert' do
          expect(json.alert.user_id).to eq(user.id)
        end

        it 'includes user vote in response' do
          expect(json.alert.user_vote).to eq(0)
        end

        it 'creates new alert' do
          expect(Alert.first.user_id).to eq(user.id)
        end
      end

      context 'submits invalid params' do
        before { post :create, alert: wrong_alert, access_token: token.token }

        it_behaves_like 'a failed create/update'

        it "doesn't create new alert" do
          expect(Alert.count).to eq(0)
        end
      end
    end

    describe 'GET#show' do
      context 'visits valid alert' do
        before { get :show, id: alert, access_token: token.token }

        it_behaves_like 'a successful request'

        it 'includes alert in response' do
          expect(json.alert.id).to eq(alert.id)
        end

        it 'includes user vote in response' do
          expect(json.alert.user_vote).to eq(0)
        end
      end

      context 'it is up voted by user' do
        let!(:confirmation) do
          create(:alert_up_confirmation, user_id: user.id, alert_id: alert.id)
        end
        before { get :show, id: alert, access_token: token.token }

        it 'includes user vote in response' do
          expect(json.alert.user_vote).to eq(1)
        end
      end

      context 'it is down voted by user' do
        let!(:confirmation) do
          create(:alert_down_confirmation, user_id: user.id, alert_id: alert.id)
        end
        before { get :show, id: alert, access_token: token.token }

        it 'includes user vote in response' do
          expect(json.alert.user_vote).to eq(-1)
        end
      end
    end

    describe 'GET#index' do
      let(:second_region) { create(:region, code_name: 'ACR') }
      let(:second_user) do
        create(:user, region_id: second_region.id, email: 'another@email.com')
      end
      let(:second_token) { access_token(app, second_user) }
      let(:alert_params) { FactoryGirl.attributes_for(:alert) }
      let!(:confirmation) do
        alert.confirmations.create(user_id: user.id, up: true)
      end

      before do
        controller.stub(:doorkeeper_token) { token }
        get :index
      end

      context 'it has created alert' do
        it_behaves_like 'a successful request'

        it 'includes alert in the list' do
          expect(json.alerts.count).to eq(1)
        end
      end

      context 'sends alert for different region' do
        it "doesn't include alert in the list" do
          post :create, alert: alert_params, access_token: second_token.token
          get :index
          expect(json.alerts.count).to eq(1)
        end
      end

      context 'user has up voted alert' do
        it 'includes user vote in response' do
          get :index, access_token: token.token
          expect(json.alerts.first.user_vote).to eq(1)
        end
      end
    end
  end
end
