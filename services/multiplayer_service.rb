require_relative 'broadcast_service'

class MultiplayerService < Domain::Api::Public::MultiplayerService::Service
  include BroadcastService

  attr_reader :loans, :action_updates, :client_updates, :live_clients

  def initialize
    @action_updates = Concurrent::Map.new
    @client_updates = Concurrent::Map.new
    @live_clients = Concurrent::Map.new

    Thread.new do
      while true
        clients = @live_clients.keys.map do |id|
          Domain::Api::WebClient.new(id: id)
        end

        update = Domain::Api::Public::ClientsUpdate.new({connected: clients})
        update_queue(update, client_updates, live_clients)
        update_queue(nil, action_updates, live_clients)

        sleep 5
      end
    end
  end

  def update(web_action, _call)
    update_queue(web_action, action_updates, live_clients)
  end

  def listen_to_action_updates(client, _call)
    broadcast_updates(client, action_updates, live_clients)
  end

  def listen_to_client_updates(client, _call)
    broadcast_updates(client, client_updates, live_clients)
  end
end
