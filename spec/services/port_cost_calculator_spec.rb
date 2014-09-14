require 'spec_helper'
require './app/services/port_cost_calculator'

describe PortCostCalculator do

  subject { PortCostCalculator.new(yacht: yacht, port: port) }

  let(:port) { create(:port) }
  let(:yacht) { create(:yacht) }

  describe 'computing port cost' do

    it 'is successful' do
      expect(subject.total_cost).to eq(110)
    end

    context 'for big yacht' do

      subject { PortCostCalculator.new(yacht: big_yacht, port: port) }
      let(:big_yacht) { create(:yacht, length: 10_000) }

      it 'has no place' do
        expect(subject.available).to be_falsey
      end
    end
  end
end
