require 'spec_helper'

describe V1::Doorkeeper::TokensController, type: :controller do

  let(:active_user) { create(:user) }
  let(:inactive_user) { create(:user, active: false, email: 'b@example.com') }
  let(:app) { create_client_app }
  let(:active_user_log_in_params) { create_login_params(active_user, app) }
  let(:inactive_user_log_in_params) { create_login_params(inactive_user, app) }

  describe 'POST#create' do
    context 'has active account' do
      before { post :create, active_user_log_in_params }

      it_behaves_like 'a successful request'

      it 'logs in user' do
        expect(json.include?('access_token')).to eq(true)
      end
    end

    context 'has inactive accound' do
      before { post :create, inactive_user_log_in_params }

      it_behaves_like 'an unauthorized request'

      it "doesn't log in user" do
        expect(json.include?('access_token')).to eq(false)
      end
    end
  end

  describe 'POST#revoke' do
    let(:token) { access_token(app, active_user) }
    let!(:device) { create(:device, token_id: token.id) }

    before do
      controller.stub(:doorkeeper_token) { token }
      post :revoke
    end

    it_behaves_like 'a successful request'

    it 'removes device' do
      expect(Device.count).to eq(0)
    end
  end
end
