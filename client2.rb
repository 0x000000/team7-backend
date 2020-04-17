require 'rubygems'
require 'bundler/setup'
require 'time'

require 'grpc'

require 'domain-ruby'

client = Domain::Api::Private::LoansService::Stub.new('45.79.77.254:10369', :this_channel_is_insecure)
client.listen_to_loan_updates(Domain::Api::Private::ClientData.new(id: Time.now.to_i)).each do |loan|
  puts loan
end
