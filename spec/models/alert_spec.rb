require 'spec_helper'

describe Alert do
  subject { create(:alert) }

  it 'has valid factory' do
    expect(build(:alert)).to be_valid
  end
end
