require 'spec_helper'

describe Slnky::Chef::Service do
  subject do
    s = described_class.new("http://localhost:3000", test_config)
    s.client = Slnky::Chef::Mock.new(test_config)
    s
  end
  let(:test_event) { event('test')}
  let(:terminated) { event('terminated')}

  it 'handles event' do
    expect(subject.handler(test_event.name, test_event.payload)).to eq(true)
  end

  it 'handles terminated' do
    expect(subject.handle_terminated(terminated.name, terminated.payload)).to eq("remove #{terminated.payload.detail['instance-id']}")
  end
end
