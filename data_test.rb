require 'rubygems'
require 'bundler/setup'

require 'grpc'

require 'domain-ruby'
require './data_generator'

p DataGenerator.generate
