require 'logger'

module Mscan
  # Utility methods for tracking Mscan measurables
  class Profiler

    def self.logger
      @logger ||= Logger.new(STDOUT)
    end

    # Measures the amount of time that is spent
    # in the given block.
    #
    # @param  [String] Optional name
    # @return [Object, Float] The result of calling the block
    #                         and the time spent in seconds
    #
    # TODO use logger instead of puts
    def self.measure(name=nil, &block)
      start_time = Time.now
      result = block.call
      total_time = Time.now - start_time
      logger.info "#{name || 'the block'} took #{total_time}s" if Mscan::Settings.verbose

      [result, total_time]
    end

  end
end