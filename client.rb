require 'rubygems'
require 'bundler/setup'

require 'grpc'

require 'domain-ruby'

def random_note
  ('a'..'z').to_a.shuffle[0,10].join
end

client = Domain::Api::Private::LoansService::Stub.new('45.79.77.254:10369', :this_channel_is_insecure)
loans = client.load_all(Google::Protobuf::Empty.new).loans

puts "Loaded loans:"
loans.each do |loan|
  puts loan
end

states = [
  Domain::Loan::State::Draft,
  Domain::Loan::State::Submitted,
  Domain::Loan::State::Approved,
  Domain::Loan::State::Rejected,
]

last_loan = loans.sample
last_loan.notes = random_note
last_loan.state = states.filter {|s| s != last_loan.state }.sample

client.update_loan(last_loan)
puts "Updated loan ##{last_loan.id}"
