module Mscan
  class Profiler

    def self.measure(message, &block)
      start_time = Time.now
      block.call
      total_time = Time.now - start_time
      puts "#{message} took #{total_time}s"
      total_time
    end

  end
end