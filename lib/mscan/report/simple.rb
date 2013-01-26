module Mscan # :nodoc:
  module Report # :nodoc:
  	class Simple
			def self.report(analysis)
				Logger.measure('Simple') do
					puts analysis.inspect

					output = "\n"
					print_scan_summary(analysis, output)
					print_analysis_summary(analysis, output)
					print_analysis_details(analysis, output)
					puts "#{output}\n"
				end
			end

			def self.print_scan_summary(analysis, output)
				output << "\nScan Summary\n"
				output << "-----------------------------------------\n"
				output << "Source directories: #{analysis['source_dirs'].join(', ')}\n"
				output << "Target directories: #{analysis['target_dirs'].join(', ')}\n"
				
				output << "Files scanned: #{analysis['num_files']} => #{to_MB(analysis['size'])}MB\n\n"
			end

			def self.print_analysis_summary(analysis, output)
				output << "\nAnalysis Summary\n"
				output << "-----------------------------------------\n"
				
				# classify unique media
				source_media, target_media, shared_media = classify_media(analysis)

				output << "Unique source media: #{source_media.size} => #{to_MB(size_from_fingerprints(analysis, source_media))}MB\n"
				output << "Unique target media: #{target_media.size} => #{to_MB(size_from_fingerprints(analysis, target_media))}MB\n"
				output << "Media shared across both source and target: #{shared_media.size} => #{to_MB(size_from_fingerprints(analysis, shared_media))}MB\n"			
			end

			def self.print_analysis_details(analysis, output)
				output << "\nAnalysis Details\n"
				output << "-----------------------------------------\n"

				source_media, target_media, shared_media = classify_media(analysis)				

				output << "\nUnique Source Media\n"
				output << "-------------------\n"

				details_from_fingerprints(analysis, source_media).each do |details|
					output << "#{details['path']}\n"
				end

				output << "\nUnique Target Media\n"
				output << "-------------------\n"
				details_from_fingerprints(analysis, target_media).each do |details|
					output << "#{details['path']}\n"
				end
			end

			def self.classify_media(analysis)
				source_media, target_media, shared_media = [], [], []
				
				source_dirs = analysis['source_dirs']
				target_dirs = analysis['target_dirs']

				unique_media_arr = analysis['unique_media'].each do |fingerprint, meta_data|
					in_source, in_target = false, false
					meta_data['media_files'].each do |media_file|
						path = media_file['path']
						if in_dir_tree?(path, source_dirs)
							in_source = true
						elsif in_dir_tree?(path, target_dirs)
							in_target = true
						end
					end

					if in_source && in_target
						shared_media << fingerprint
					elsif in_source
						source_media << fingerprint
					elsif in_target
						target_media << fingerprint
					end

				end

				[source_media, target_media, shared_media]	
			end

			def self.in_dir_tree?(path, dirs)
				dirs.each do |dir|
					return true if path =~ /#{dir}/ 
				end
				false
			end

			def self.size_from_fingerprints(analysis, fingerprints)
				fingerprints.inject(0) do |total_size, fingerprint|
					total_size += analysis['unique_media'][fingerprint]['size']
				end
			end

			def self.details_from_fingerprints(analysis, fingerprints)
				unique_media = analysis['unique_media']
				fingerprints.map do |fingerprint|
					media_files_details = unique_media[fingerprint]['media_files']
					{'path' => media_files_details.first['path']}
				end
			end

			def self.to_MB(number)
				(number.to_f / (1024 * 1024)).round(3) 
			end

  	end
  end
end