module Slnky
  module Chef
    class Service < Slnky::Service::Base

      attr_writer :client
      def client
        @client ||= Slnky::Chef::Client.new(config)
      end

      subscribe 'aws.ec2.terminated', :handle_terminated
      subscribe 'chef.run.*', :handle_chef

      def handle_terminated(name, data)
        id = data.detail['instance-id']
        client.remove_instance(id)
      end

      def handle_chef(name, data)
        if name == 'chef.run.failure'
          name = data.attributes ? "#{data.attributes.name}-#{data.attributes.cluster}" : ""
          log :error, "chef run failed on #{data.node} #{name}"
        end
      end

      def handler(name, data)
        # for example test
        name == 'slnky.service.test' && data.hello == 'world!'
      end
    end
  end
end
