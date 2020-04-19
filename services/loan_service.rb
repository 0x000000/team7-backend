require_relative '../helpers/data_generator'
require_relative 'broadcast_service'

class LoansService < Domain::Api::Private::LoansService::Service
  include BroadcastService

  attr_reader :loans, :updates, :live_clients

  def initialize
    @loans = DataGenerator.generate
    @updates = Concurrent::Map.new
    @live_clients = Concurrent::Map.new
  end

  def load_all(_, _call)
    loans.values
  end

  def update(updated_loan, _call)
    updated_loan.updated_at = DataGenerator.current_time
    loans[updated_loan.id] = updated_loan

    update_queue(updated_loan, updates, live_clients)
  end

  def listen_to_updates(client, _call)
    broadcast_updates(client, updates, live_clients)
  end
end
