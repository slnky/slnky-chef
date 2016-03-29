module Slnky
  module Chef
    class Mock
      def initialize(config)
        @url = config.chef.url
        @client = config.chef.client
        @key = config.chef.key
        @env = config.environment
      end

      def remove_instance(name)
        "remove #{name}"
      end
    end
  end
end
