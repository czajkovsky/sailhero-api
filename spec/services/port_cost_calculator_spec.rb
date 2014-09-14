require 'spec_helper'
require './app/services/port_cost_calculator'

describe PortCostCalculator do

  subject { PortCostCalculator.new(yacht, port) }

  let(:port) { create(:port) }
  let(:yacht) { create(:yacht) }

  describe 'computing port cost' do

    it 'is successful' do
      expect(subject.total_cost).to eq(110)
    end

  end
end
