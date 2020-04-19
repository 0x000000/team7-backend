require 'logger'

module RubyLogger
  def logger
    LOGGER
  end

  LOGGER = Logger.new(STDOUT)
end

module GRPC
  # Inject the noop #logger if no module-level logger method has been injected.
  extend RubyLogger
end

