module Slnky
  module Chef
    class Command < Slnky::Command::Base
      attr_writer :client
      def client
        @client ||= Slnky::Chef::Client.new(config)
      end

      def echo(request, response)
        opts = options(request.args) do |slop|
          slop.on "-h", "--help", "print help"
          slop.int "-x", "--times", "print x times", default: 1
        end
        args = opts.args
        response.output opts.to_hash.inspect
        response.output args.inspect
      rescue => e
        response.error "error: #{e.message} at #{e.backtrace.first}"
      end
    end
  end
end
