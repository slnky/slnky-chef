module Slnky
  module Chef
    class Command < Slnky::Command::Base
      attr_writer :client

      def client
        @client ||= Slnky::Chef::Client.new
      end

      # command :echo, 'respond with the given arguments', <<-USAGE.strip_heredoc
      #   Usage: echo [options] ARGS...
      #
      #   -h --help           print help.
      #   -x --times=TIMES    print x times [default: 1].
      # USAGE
      #
      # def handle_echo(request, response, opts)
      #   args = opts.args
      #   1.upto(opts.times.to_i) do |i|
      #     log.info args.join(" ")
      #   end
      # end

      command :cleanup, 'clean up orphan clients and nodes', <<-USAGE.strip_heredoc
        Usage: cleanup [options]

        -h --help           print help.
      USAGE

      def handle_cleanup(request, response, opts)
        log.info 'cleaning up orphan clients and nodes'
        client.cleanup
      end

      command :remove, 'remove node and client matching NAME', <<-USAGE.strip_heredoc
        Usage: remove [options] NAME

        NAME can be an instance id or short hostname (not fqdn)
        -h --help           print help.
      USAGE

      def handle_remove(request, response, opts)
        name = opts.name

        # single instance id
        if name =~ /^i-\d{8,12}$/
          if client.client(name) || client.node(name)
            log.info "removing chef node and client named '#{name}'"
            client.remove_instance(name)
          else
            log.info "node and client '#{name}' doesn't exist"
          end
          return
        end

        # search nodes for name
        list = client.search_node(name)
        if list.count == 0
          log.info "no nodes matching name: '#{name}'"
        elsif list.count > 1
          log.info "#{list.count} nodes found: #{list.map { |e| e.id }.join(',')}"
        else
          # single element in list
          id = list.first.chef_id
          log.info "removing chef node and client named '#{id}'"
          # client.remove_instance(name)
        end
      end
    end
  end
end
