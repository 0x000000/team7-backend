require 'rubygems'
require 'bundler/setup'

require 'grpc'

require 'domain-ruby'
require_relative 'data_generator'
require_relative 'services/loan_service'

loan_service = LoansService.new(DataGenerator.generate)

server = GRPC::RpcServer.new
server.add_http2_port('0.0.0.0:10369', :this_port_is_insecure)

server.handle(loan_service)

server.run_till_terminated_or_interrupted([1, 'int', 'SIGQUIT'])
