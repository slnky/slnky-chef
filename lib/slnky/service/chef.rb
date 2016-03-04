require 'slnky'

require 'ridley'
Ridley::Logging.logger.level = Logger.const_get 'ERROR'

module Slnky
  module Service
    class Chef < Base
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
              server_url: ENV['CHEF_URL'],
              client_name: ENV['CHEF_CLIENT'],
              client_key: ENV['CHEF_KEY'],
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
