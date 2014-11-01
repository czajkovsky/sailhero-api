require 'spec_helper'

describe Region do
  subject { create(:region) }

  it 'has valid factory' do
    expect(build(:region)).to be_valid
  end
end
