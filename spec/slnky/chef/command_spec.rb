require 'spec_helper'

describe Slnky::Chef::Command do
  subject do
    s = described_class.new(test_config)
    s.client = Slnky::Chef::Mock.new(test_config)
    s
  end
  let(:echo) { command('echo').payload }
  let(:response) { Slnky::Command::Response.new("test", "test") }

  it 'handles echo' do
    resp = response
    expect { subject.handle_echo(echo, resp) }.to_not raise_error
    expect(resp.output).to eq("test echo")
  end
end
