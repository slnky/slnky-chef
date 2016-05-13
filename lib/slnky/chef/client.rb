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

      def client(id)
        ridley.client.find(id)
      end

      def node(id)
        ridley.node.find(id)
      end

      def search_node(name)
        ridley.search(:node, "hostname:*#{name}*").map do |e|
          e.chef_attributes
        end
      end

      def remove_instance(id)
        Timeout.timeout(@timeout) do
          node = node(id)
          client = client(id)
          ridley.node.delete(id) if node
          ridley.client.delete(id) if client
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
