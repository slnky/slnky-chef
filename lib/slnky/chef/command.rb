module Slnky
  module Chef
    class Command < Slnky::Command::Base
      attr_writer :client
      def client
        @client ||= Slnky::Chef::Client.new(config)
      end

      def echo(request, response)
        opts = options(request.args) do |slop|
          slop.banner = "usage: echo [options] ..."
          slop.on "-h", "--help", "print help" do
            return response.output slop.to_s
          end
          slop.int "-x", "--times", "print x times", default: 1
        end
        args = opts.args
        1.upto(opts[:times]) do |i|
          response.output args.join(" ")
        end
      rescue => e
        response.error "error: #{e.message} at #{e.backtrace.first}"
      end
    end
  end
end
