require 'action_view/helpers/number_helper'

module Mscan
	module Report
		module Helper
			include ActionView::Helpers::NumberHelper

			THOUSANDS_DELIMITER = ','

			def to_files(number)
				formatted_number = number_with_delimiter(number,:delimiter => THOUSANDS_DELIMITER)
				"#{formatted_number} files"
			end

			def to_MB(number)
				formatted_number = (number.to_f / (1024 * 1024)).round(3)
				"#{formatted_number}MB"
			end
		end
	end
end