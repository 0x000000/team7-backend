require 'rubygems'
require 'bundler/setup'

require 'grpc'

require 'domain-ruby'

# def random_note
#   ('a'..'z').to_a.shuffle[0,10].join
# end
#
#
# client = Domain::Api::Private::LoansService::Stub.new('localhost:10369', :this_channel_is_insecure)
# loans = client.load_all(Google::Protobuf::Empty.new)
#
# puts "Loaded loans: #{loans.size}"
#
# states = [
#   Domain::Loan::State::Draft,
#   Domain::Loan::State::Submitted,
#   Domain::Loan::State::Approved,
#   Domain::Loan::State::Rejected,
# ]
#
# last_loan = loans.to_a.sample
# last_loan.notes = random_note
# last_loan.state = states.filter {|s| s != last_loan.state }.sample
#
# client.update(last_loan)
# puts "Updated loan ##{last_loan.id}"

user = Domain::Api::WebClient.new(id: Time.now.to_i)
client = Domain::Api::Public::MultiplayerService::Stub.new('localhost:10369', :this_channel_is_insecure)
client.update(Domain::Api::Public::WebAction.new({
  client: user,
  type: Domain::Api::Public::WebAction::Type::ACQUIRED,
  element_locator: "test",
}))
