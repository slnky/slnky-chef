module Slnky
  module Chef
    class Command < Slnky::Command::Base
      attr_writer :client
      def client
        @client ||= Slnky::Chef::Client.new(config)
      end

      command :echo, "respond with the given arguments", <<-USAGE.strip_heredoc
        Usage: echo [options] ARGS...

        -h --help           print help.
        -x --times=TIMES    print x times [default: 1].
      USAGE

      command :remove, "remove node and client matching NAME", <<-USAGE.strip_heredoc
        Usage: remove [options] NAME

        -h --help           print help.
      USAGE

      def handle_echo(request, response, opts)
        args = opts.ARGS
        1.upto(opts.times.to_i) do |i|
          response.output args.join(" ")
        end
      rescue => e
        response.error "#{__method__}: #{e.message} at #{e.backtrace.first}"
      end

      def handle_remove(request, response, opts)
        name = opts.NAME
        response.output name
      rescue => e
        response.error "#{__method__}: #{e.message} at #{e.backtrace.first}"
      end

      def help(request, response)
        response.output '  echo     just respond with the arguments given'
        response.output '  remove   remove node and client matching NAME'
      end
    end
  end
end
