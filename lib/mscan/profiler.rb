module Mscan
  # Utility methods for tracking Mscan measurables
  class Profiler

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
      puts "#{name || 'the block'} took #{total_time}s"

      [result, total_time]
    end

  end
end