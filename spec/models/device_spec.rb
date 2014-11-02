require 'spec_helper'

describe Device do
  subject { create(:device) }

  it 'has valid factory' do
    expect(build(:device)).to be_valid
  end
end
