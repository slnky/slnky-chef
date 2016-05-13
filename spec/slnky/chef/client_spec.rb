require 'spec_helper'

describe Slnky::Chef::Client, remote: true do
  subject { described_class.new }

  context '#node' do
    it 'handles missing node' do
      expect(subject.node('i-12345678')).to be_nil
    end

    it 'handles found node' do
      expect(subject.node('i-165e6b92')).not_to be_nil
    end
  end

  context '#search' do
    it 'handles search for missing name' do
      expect(subject.search_node('blarg').count).to eq(0)
    end

    it 'handles search for more than 1' do
      expect(subject.search_node('tools-ops')).not_to be_empty
    end

    it 'handles search for single matching' do
      expect(subject.search_node('staging01-apricot').count).to eq(1)
    end
  end

  # subject do
  #   s = described_class.new
  #   s.client = Slnky::Chef::Mock.new
  #   s
  # end
  # let(:echo) { slnky_command('echo') }
  # let(:help) { slnky_command('help') }
  # let(:remove) { slnky_command('remove') }
  # let(:echo_response) { slnky_response('test-route', 'spec') }
  # let(:help_response) { slnky_response('test-route', 'spec') }
  # let(:remove_response) { slnky_response('test-route', 'spec') }

  # it 'handles echo' do
  #   expect { subject.handle(echo.name, echo.payload, echo_response) }.to_not raise_error
  #   expect(echo_response.trace).to include("test echo")
  # end

  # it 'handles help' do
  #   expect { subject.handle(help.name, help.payload, help_response) }.to_not raise_error
  #   expect(help_response.trace).to include("chef help: print help")
  # end
  #
  # it 'handles remove' do
  #   expect { subject.handle(remove.name, remove.payload, remove_response) }.to_not raise_error
  #   expect(remove_response.trace).to include("node and client 'i-12345678' doesn't exist")
  # end
end
