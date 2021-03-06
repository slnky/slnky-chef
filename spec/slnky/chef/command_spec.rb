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
  let(:cleanup) { slnky_command('cleanup') }
  let(:echo_response) { slnky_response('test-route', 'spec') }
  let(:help_response) { slnky_response('test-route', 'spec') }
  let(:remove_response) { slnky_response('test-route', 'spec') }
  let(:cleanup_response) { slnky_response('test-route', 'spec') }

  # it 'handles echo' do
  #   expect { subject.handle(echo.name, echo.payload, echo_response) }.to_not raise_error
  #   expect(echo_response.trace).to include("test echo")
  # end

  context '#help' do
    it 'handles help' do
      expect { subject.handle(help.name, help.payload, help_response) }.to_not raise_error
      expect(help_response.trace).to include("chef help: print help")
    end
  end

  context '#remove' do
    it 'handles remove' do
      expect { subject.handle(remove.name, remove.payload, remove_response) }.to_not raise_error
      expect(remove_response.trace).to include("node and client 'i-12345678' doesn't exist")
    end
  end

  context '#cleanup' do
    it 'handles cleanup' do
      expect { subject.handle(cleanup.name, cleanup.payload, cleanup_response) }.to_not raise_error
      expect(cleanup_response.trace).to include("removed 1 node")
    end
  end
end
