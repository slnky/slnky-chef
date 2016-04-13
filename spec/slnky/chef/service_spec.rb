require 'spec_helper'

describe Slnky::Chef::Service do
  subject do
    s = described_class.new
    s.client = Slnky::Chef::Mock.new
    s
  end
  let(:test_event) { slnky_event('test')}
  let(:terminated) { slnky_event('terminated')}

  it 'handles event' do
    expect(subject.handler(test_event.name, test_event.payload)).to eq(true)
  end

  it 'handles terminated' do
    expect(subject.handle_terminated(terminated.name, terminated.payload)).to eq("remove #{terminated.payload.detail['instance-id']}")
  end
end
