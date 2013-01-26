module Mscan # :nodoc:
  # Reports Mscan analysis
  class Reporter
		include Store

		REPORTS = [Mscan::Report::Simple, Mscan::Report::Html]

		def self.report
			Logger.measure('Reporting') do
				most_recent_analysis = load_most_recent("#{ANALYSIS_OUTPUT_DIR}/#{ANALYSIS_FILE_NAME}")

				# Pass analysis through reports
				REPORTS.each do |report_class|
				  report_class.report(most_recent_analysis)
				end
		  end
		end

  end
end