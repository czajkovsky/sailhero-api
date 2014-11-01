require 'spec_helper'

describe Yacht do
  subject { create(:alert) }

  it 'has valid factory' do
    expect(build(:alert)).to be_valid
  end
end
