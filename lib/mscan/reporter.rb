module Mscan # :nodoc:
  # Reports Mscan analysis
  class Reporter
		include Store

		# Mscan::Report::Html
		REPORTS = [Mscan::Report::Simple]

		def self.report(options={})
			Logger.measure('Reporting') do
				most_recent_analysis = load_most_recent("#{ANALYSIS_OUTPUT_DIR}/#{ANALYSIS_FILE_NAME}")

				# Pass analysis through reports
				REPORTS.each do |report_class|
				  report_class.report(most_recent_analysis,options)
				end
		  end
		end

  end
end