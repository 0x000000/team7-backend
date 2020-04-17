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

last_loan = loans.sample
last_loan.notes = random_note

client.update_loan(last_loan)
puts "Updated loan ##{last_loan.id}"
