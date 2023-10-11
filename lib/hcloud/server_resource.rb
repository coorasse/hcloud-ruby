# frozen_string_literal: true

module Hcloud
  class ServerResource < AbstractResource
    filter_attributes :status, :name, :label_selector

    bind_to Server

    def create(name:,
               server_type:,
               image:, datacenter: nil,
               location: nil,
               start_after_create: nil,
               ssh_keys: [],
               public_net: nil,
               firewalls: nil,
               networks: [],
               placement_group: nil,
               user_data: nil,
               volumes: nil,
               automount: nil,
               labels: {})
      prepare_request('servers', j: COLLECT_ARGS.call(__method__, binding),
                                 expected_code: 201) do |response|
        [
          Action.new(client, response.parsed_json[:action]),
          Server.new(client, response.parsed_json[:server]),
          response.parsed_json[:root_password],
          response.parsed_json[:next_actions].to_a.map do |action|
            Action.new(client, action)
          end
        ]
      end
    end

    def [](arg)
      case arg
      when Integer then find_by(id: arg)
      when String then find_by(name: arg)
      end
    end
  end
end
