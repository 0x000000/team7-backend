module BroadcastService
  POOL_WAIT_SEC = 0.5
  IDLE_CLIENT_SEC = 10

  def update_queue(updated_message, updates, live_clients)
    current_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)

    dead_clients = []
    updates.each do |client_id, client_queue| #send update for each client queue
      if live_clients[client_id] && current_time - live_clients[client_id] < IDLE_CLIENT_SEC
        client_queue.push(updated_message) if updated_message # allow noop updates
      else
        dead_clients.push(client_id)
      end
    end

    dead_clients.each do |client_id|
      GRPC.logger.warn("DELETED client #{client_id}")
      updates.delete(client_id)
      live_clients.delete(client_id)
    end

    Google::Protobuf::Empty.new
  end

  def broadcast_updates(client, updates, live_clients)
    updates[client.id] = []
    live_clients[client.id] = Process.clock_gettime(Process::CLOCK_MONOTONIC)

    Enumerator.new do |enum|
      while true
        loop do
          update = updates[client.id].shift
          if update
            enum.yield(update)
          else
            break
          end
        end

        live_clients[client.id] = Process.clock_gettime(Process::CLOCK_MONOTONIC)
        sleep POOL_WAIT_SEC
      end
    end
  end
end
