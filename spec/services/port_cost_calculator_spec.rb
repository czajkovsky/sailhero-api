require 'spec_helper'
require './app/services/port_cost_calculator'

describe PortCostCalculator do

  subject { PortCostCalculator.new(yacht: yacht, port: port).call }

  let(:port) { create(:port) }
  let(:yacht) { create(:yacht) }

  describe 'computing port cost' do

    context 'has place for yacht' do
      it 'sets proper cost' do
        expect(subject.cost).to eq(110)
      end

      it 'includes currency' do
        expect(subject.as_json[:currency]).to eq(port.currency)
      end

      it 'includes additional info' do
        expect(subject.as_json[:additional_info]).to eq(port.additional_info)
      end

      it 'includes options in optional/included arrays' do
        expect(subject.optional.count).not_to eq(0)
        expect(subject.included.count).not_to eq(0)
      end
    end

    context 'for too big yacht' do
      subject { PortCostCalculator.new(yacht: big_yacht, port: port).call }
      let(:big_yacht) { create(:yacht, length: 3_000) }

      it 'renders no cost' do
        expect(subject.cost).to eq(nil)
      end

      it 'does not include options in optional/included arrays' do
        expect(subject.optional.count).to eq(0)
        expect(subject.included.count).to eq(0)
      end
    end
  end
end
