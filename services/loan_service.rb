class LoansService < Domain::Api::Private::LoansService::Service
  attr_reader :loans, :updates

  def initialize(loans)
    @loans = loans
    @updates = {}
  end

  def load_all(_, _call)
    puts "LoansService#load_all"

    Domain::Api::Private::AllLoansResponse.new(loans: loans.values)
  end

  def update_loan(updated_loan, _call)
    puts "LoansService#update_loan"

    updated_loan.updated_at = DataGenerator.current_time
    loans[updated_loan.id] = updated_loan

    updates.values.each do |client_queue| #update loan for each client queue
      client_queue.push(updated_loan)
    end

    Google::Protobuf::Empty.new
  end

  def listen_to_loan_updates(client, _call)
    puts "LoansService#listen_to_loan_updates, #{client.id}"

    updates[client.id] = []

    Enumerator.new do |enum|
      while true
        updated_loan = updates[client.id].pop
        if updated_loan
          enum.yield(updated_loan)
          puts "Updated loan #{updated_loan.id}, for client #{client.id}"
        end

        sleep 0.5
      end
    end
  end
end
