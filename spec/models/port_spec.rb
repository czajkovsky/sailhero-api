require 'spec_helper'

describe Port do
  subject { create(:port) }

  it 'has valid factory' do
    expect(build(:port)).to be_valid
  end
end
