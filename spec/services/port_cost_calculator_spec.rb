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

    context 'for too big yacht' do
      subject { PortCostCalculator.new(yacht: big_yacht, port: port) }
      let(:big_yacht) { create(:yacht, length: 3_000) }

      it 'is unavailable' do
        expect(subject.available).to be_falsey
      end

      it 'renders no cost' do
        expect(subject.serialize[:cost]).to eq('---')
      end
    end
  end
end
