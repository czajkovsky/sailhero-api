require 'spec_helper'

describe ActivationsController, type: :controller do

  let(:user) { create(:user) }

  describe '#GET activate' do
    before do
      get :activate, token: user.activation_token
      user.reload
    end

    it 'activates user' do
      expect(user.active).to eq(true)
    end

    it 'removes confirmation token' do
      expect(user.activation_token).to eq('')
    end
  end
end
