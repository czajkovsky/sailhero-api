require 'spec_helper'

describe User do
  subject { create(:user) }

  it 'has valid factory' do
    expect(build(:user)).to be_valid
  end

  describe '#authenticate' do
    let(:user_params) { FactoryGirl.attributes_for(:user) }
    let(:wrong_user_params) do
      FactoryGirl.attributes_for(:user, password: 'wrong password')
    end

    it 'authenticates user' do
      user = User.create(user_params)
      authenticated = User.authenticate!(user_params[:email],
                                         user_params[:password])
      expect(authenticated).to eq(user)
    end

    it 'does not authenticate user with wrong credentials' do
      User.create(user_params)
      authenticated = User.authenticate!(wrong_user_params[:email],
                                         wrong_user_params[:password])
      expect(authenticated).to be_nil
    end
  end
end
