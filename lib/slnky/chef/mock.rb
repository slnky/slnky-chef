module Slnky
  module Chef
    class Mock < Slnky::Chef::Client
      def initialize
        @url = config.chef.url
        @client = config.chef.client
        @key = config.chef.key
        @env = config.environment
      end

      def client(id)
        nil
      end

      def node(id)
        nil
      end

      def search_node(name)
        []
      end

      def cleanup
        log.info 'removed 1 node' # to validate command/response
        'removed 1 node' # to validate service/handler
      end

      def remove_instance(name)
        log.info name # to validate command/response
        "remove #{name}" # to validate service/handler
      end
    end
  end
end
