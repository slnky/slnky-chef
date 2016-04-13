module Slnky
  module Chef
    class Mock
      def initialize
        @config = Slnky.config
        @url = @config.chef.url
        @client = @config.chef.client
        @key = @config.chef.key
        @env = @config.environment
        @log = Slnky.log
      end

      def remove_instance(name)
        "remove #{name}"
      end
    end
  end
end
