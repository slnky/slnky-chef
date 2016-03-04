require 'slnky'

require 'ridley'
Ridley::Logging.logger.level = Logger.const_get 'ERROR'

module Slnky
  module Service
    class Chef < Base
      def initialize(url)
        super(url)
        @chef_url = @config['chef']['url']
        @chef_client = @config['chef']['client']
        @chef_key = @config['chef']['key']
      end

      def run
        subscribe 'aws.ec2.terminated' do |message|
          name = message.name
          data = message.payload
          id = data.detail['instance-id']
          remove_instance(id)
        end
      end

      def ridley
        @ridley ||= begin
          config = {
              server_url: @chef_url,
              client_name: @chef_client,
              client_key: @chef_key,
              ssl: {
                  verify: false
              }
          }
          Ridley.new(config)
        end
      end

      def remove_instance(name)
        node = ridley.node.find(name)
        client = ridley.client.find(name)
        if node
          log :info, "remove node #{node.name}"
          ridley.node.delete(name)
        else
          log :info, "node #{name} not found"
        end
        if client
          log :info, "remove client #{node.name}"
          ridley.client.delete(name)
        else
          log :info, "client #{name} not found"
        end
      end
    end
  end
end
