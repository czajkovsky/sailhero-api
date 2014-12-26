require 'spec_helper'
require './app/services/gcm_pusher'

describe GCMPusher do

  subject { GCMPusher.new(data: { message: 'm' }, collapse_key: 'k') }

  let(:port) { create(:port) }
  let(:yacht) { create(:yacht) }

  describe 'sending gcm messages' do
    it 'responds do call' do
      expect(subject.call[:body]).not_to eq(nil)
    end
  end
end
