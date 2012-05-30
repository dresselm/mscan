require 'logger'

module Mscan
  # Utility methods for tracking Mscan measurables
  class Profiler

    # Returns the logger instance
    #
    # @return [Logger] the logger instance
    def self.logger
      @logger ||= Logger.new(STDOUT)
    end

    # Measures the amount of time that is spent
    # in the given block.
    #
    # @param  name [String] The optional name
    # @return [Object, Float] The result of calling the block
    #                         and the time spent in seconds
    def self.measure(name=nil, &block)
      start_time = Time.now
      result = block.call
      total_time = Time.now - start_time
      logger.info "#{name || 'the block'} took #{total_time}s" if Mscan::Settings.verbose

      [result, total_time]
    end

  end
end