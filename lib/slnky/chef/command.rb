module Slnky
  module Chef
    class Command < Slnky::Command::Base
      attr_writer :client
      def client
        @client ||= Slnky::Chef::Client.new
      end

      command :echo, 'respond with the given arguments', <<-USAGE.strip_heredoc
        Usage: echo [options] ARGS...

        -h --help           print help.
        -x --times=TIMES    print x times [default: 1].
      USAGE

      def handle_echo(request, response, opts)
        args = opts.args
        1.upto(opts.times.to_i) do |i|
          log.info args.join(" ")
        end
      end

      command :remove, 'remove node and client matching NAME', <<-USAGE.strip_heredoc
        Usage: remove [options] NAME

        -h --help           print help.
      USAGE

      def handle_remove(request, response, opts)
        name = opts.name
        log.info "running client remove #{name}"
        client.remove_instance(name)
      end
    end
  end
end
