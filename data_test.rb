require 'rubygems'
require 'bundler/setup'

require 'grpc'

require 'domain-ruby'
require './helpers/data_generator'

p DataGenerator.generate
