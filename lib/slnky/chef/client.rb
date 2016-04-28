require 'ridley'
Ridley::Logging.logger.level = Logger.const_get 'ERROR'
require 'timeout'

module Slnky
  module Chef
    class Client < Slnky::Client::Base
      def initialize
        @url = config.chef.url
        @client = config.chef.client
        @key = config.chef.key
        @timeout = config.chef.timeout || 10
        @env = config.environment
      end

      def client(name)
        ridley.client.find(name)
      end

      def node(name)
        ridley.node.find(name)
      end

      def remove_instance(name)
        Timeout.timeout(@timeout) do
          node = node(name)
          client = client(name)
          ridley.node.delete(name) if node
          ridley.client.delete(name) if client
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
