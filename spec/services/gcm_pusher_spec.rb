require 'spec_helper'
require './app/services/gcm_pusher'

describe GCMPusher do

  subject do
    keys = [device.key]
    GCMPusher.new(data: { message: 'm' }, collapse_key: 'k', devices: keys)
  end

  let(:port) { create(:port) }
  let(:yacht) { create(:yacht) }
  let(:device) { create(:device) }

  describe 'sending gcm messages' do
    it 'responds do call' do
      expect(subject.call.first[:body]).not_to eq(nil)
    end
  end
end
