require 'spec_helper'

describe ActivationsController, type: :controller do
  render_views

  let(:user) { create(:user) }

  describe '#GET activate' do
    before do
      get :activate, token: user.activation_token
      user.reload
    end

    it 'activates user' do
      expect(user.active).to eq(true)
    end

    it 'includes message' do
      expect(response.body).to include('Your account is now activated.')
    end

    it 'removes confirmation token' do
      expect(user.activation_token).to eq('')
    end
  end
end
