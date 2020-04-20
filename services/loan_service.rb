require_relative '../helpers/data_generator'

class LoansService < Domain::Api::Private::LoansService::Service
  POOL_WAIT_SEC = 0.3

  attr_reader :loans, :updates, :live_clients

  def initialize
    @loans = DataGenerator.generate
    @updates = Concurrent::Map.new
  end

  def load_all(_, _call)
    loans.values
  end

  def update(updated_loan, _call)
    updated_loan.updated_at = DataGenerator.current_time
    loans[updated_loan.id] = updated_loan

    updates.each do |_client_id, client_queue| #send update for each client queue
      client_queue.push(updated_loan)
    end

    Google::Protobuf::Empty.new
  end

  def listen_to_updates(client, _call)
    updates[client.id] = []

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

        sleep POOL_WAIT_SEC
      end
    end
  end
end
