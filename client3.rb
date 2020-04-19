require 'rubygems'
require 'bundler/setup'
require 'time'

require 'grpc'

require 'domain-ruby'

# deadline = Time.now + 3
# client = Domain::Api::Private::LoansService::Stub.new('localhost:10369', :this_channel_is_insecure)
# client.listen_to_updates(Domain::Api::WebClient.new(id: Time.now.to_i), {deadline: deadline}).each do |loan|
#   puts loan
# end


user = Domain::Api::WebClient.new(id: Time.now.to_i)
client = Domain::Api::Public::MultiplayerService::Stub.new('localhost:10369', :this_channel_is_insecure)

client.listen_to_client_updates(user).each do |client_update|
  puts client_update
end

