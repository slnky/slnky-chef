module Slnky
  module Chef
    class Command < Slnky::Command::Base
      attr_writer :client
      def client
        @client ||= Slnky::Chef::Client.new(config)
      end

      def echo(request, response)
        # pong
        args = request.args
        response.output = args.join(" ")
      end
    end
  end
end
