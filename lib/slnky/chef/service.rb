module Slnky
  module Chef
    class Service < Slnky::Service::Base

      attr_writer :client
      def client
        @client ||= Slnky::Chef::Client.new
      end

      subscribe 'aws.ec2.terminated', :handle_terminated
      subscribe 'chef.run.*', :handle_chef

      def handle_terminated(name, data)
        id = data.detail['instance-id']
        client.remove_instance(id)
      end

      def handle_chef(name, data)
        host = data.attributes ? "#{data.attributes.name}-#{data.attributes.cluster}" : ""
        if name == 'chef.run.failure'
          last = @failures[data.node]
          @failures[data.node] = Time.now
          return if last && (Time.now - last) < 24.hours
          log :error, "chef run failed on #{data.node} #{host}"
        elsif name == 'chef.run.success'
          if @failures[data.node]
            @failures[data.node] = false
            log :warn, "chef run succeeded on #{data.node} #{host}"
          end
        end
      end

      def handler(name, data)
        # for example test
        name == 'slnky.service.test' && data.hello == 'world!'
      end
    end
  end
end
