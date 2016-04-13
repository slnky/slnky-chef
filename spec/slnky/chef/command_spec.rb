require 'spec_helper'

describe Slnky::Chef::Command do
  subject do
    s = described_class.new
    s.client = Slnky::Chef::Mock.new
    s
  end
  let(:echo) { slnky_command('echo') }
  let(:help) { slnky_command('help') }
  let(:remove) { slnky_command('remove') }
  let(:echo_response) { slnky_response('test-route', 'spec') }
  let(:help_response) { slnky_response('test-route', 'spec') }
  let(:remove_response) { slnky_response('test-route', 'spec') }

  it 'handles echo' do
    expect { subject.handle(echo.name, echo.payload, echo_response) }.to_not raise_error
    expect(echo_response.log).to include("test echo")
  end

  it 'handles help' do
    expect { subject.handle(help.name, help.payload, help_response) }.to_not raise_error
    expect(help_response.log).to include("chef help: print help")
  end

  it 'handles remove' do
    expect { subject.handle(remove.name, remove.payload, remove_response) }.to_not raise_error
    expect(remove_response.log).to include("i-12345678")
  end
end
