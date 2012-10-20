module Mscan
  # Utility methods for tracking Mscan measurables
  class Logger

    # Returns the logger instance
    #
    # @return [Logger] the logger instance
    def self.logger
      @logger ||= begin
        this_logger = ::Logger.new(STDOUT)
        this_logger.level = Mscan::Config.log_level
        this_logger
      end
    end

    # Measures the amount of time that is spent
    # in the given block.
    #
    # @param  name [String] The optional name
    # @return [Object, Float] The result of calling the block
    #                         and the time spent in seconds
    def self.measure(name=nil, &block)
      start_time = Time.now
      result = block.call if block_given?
      total_time = Time.now - start_time
      logger.info "#{name || 'the block'} took #{total_time}s"

      [result || name, total_time]
    end

  end
end