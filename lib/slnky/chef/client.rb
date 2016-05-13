require 'ridley'
Ridley::Logging.logger.level = Logger.const_get 'ERROR'
require 'timeout'
require 'aws-sdk'

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

      def cleanup
        nodes = ridley.node.all
        instances = ec2.instances(filters: [{name: 'instance-state-name', values: ['running']}])
        chef_node_ids = nodes.map { |c| c.chef_id }
        aws_node_ids = instances.map { |i| i.instance_id }
        terminated_nodes = chef_node_ids - aws_node_ids

        terminated_nodes.each do |id|
          remove_instance(id) if @env == 'production'
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

      def ec2
        @ec2 ||= begin
          cfg = {
              region: config.aws.region,
              credentials: Aws::Credentials.new(config.aws.key, config.aws.secret)
          }
          Aws.config.update(cfg)
          Aws::EC2::Resource.new
        end
      end
    end
  end
end
