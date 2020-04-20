require 'rubygems'
require 'bundler/setup'

require 'grpc'
require 'concurrent'
require 'domain-ruby'

require_relative 'helpers/logger'
require_relative 'services/loan_service'

server = GRPC::RpcServer.new
server.add_http2_port('0.0.0.0:10369', :this_port_is_insecure)

server.handle(LoansService.new)

server.run_till_terminated_or_interrupted([1, 'int', 'SIGQUIT'])
