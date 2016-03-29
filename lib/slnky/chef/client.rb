require 'ridley'
Ridley::Logging.logger.level = Logger.const_get 'ERROR'

module Slnky
  module Chef
    class Client
      def initialize(config)
        @url = config.chef.url
        @client = config.chef.client
        @key = config.chef.key
        @env = config.environment
      end

      def remove_instance(name)
        node = ridley.node.find(name)
        client = ridley.client.find(name)
        if node
          log :warn, "remove node #{node.name}"
          ridley.node.delete(name)
        else
          log :info, "node #{name} not found"
        end
        if client
          log :warn, "remove client #{node.name}"
          ridley.client.delete(name)
        else
          log :info, "client #{name} not found"
        end
      end

      protected

      def ridley
        @ridley ||= begin
          config = {
              server_url: @url,
              client_name: @client,
              client_key: @key,
              ssl: {
                  verify: false
              }
          }
          Ridley.new(config)
        end
      end
    end
  end
end
