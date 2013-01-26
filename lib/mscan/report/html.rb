module Mscan # :nodoc:
  module Report # :nodoc:
  	class Html
  		
  		def self.report(analysis)
  			Logger.measure('Html') do
					# puts analysis.inspect
				end
  		end

  	end
  end
end