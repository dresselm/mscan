require 'rainbow'

module Mscan # :nodoc:
  module Report # :nodoc:
  	class Simple
  		extend Helper

			def self.report(analysis, options={})
				Logger.measure('Simple') do
					output = "\n"
					print_scan_summary(analysis, output)
					print_analysis_summary(analysis, output)
					print_analysis_details(analysis, output) if options.fetch(:verbose, false)
					puts "#{output}\n"
				end
			end

			def self.print_scan_summary(analysis, output)
				output << print_header('Scan Summary')
				output << print_title_value('Source directories',analysis['source_dirs'].join(', '))
				output << print_title_value('Target directories',analysis['target_dirs'].join(', '))
				
				output << print_title_value('Total files scanned',"#{to_files(analysis['num_files'])} => #{to_MB(analysis['size'])}")
				output << print_title_value('Unique files',"#{to_files(analysis['num_unique_files'])} => #{to_MB(analysis['unique_size'])}")
				output << print_title_value('Duplicate files',"#{to_files(analysis['num_duplicate_files'])} => #{to_MB(analysis['size'] - analysis['unique_size'])}")
			end

			def self.print_analysis_summary(analysis, output)
				output << print_header('Analysis Summary')

				# classify unique media
				source_media, target_media, shared_media = classify_media(analysis)
				total_files          = analysis['num_files']
				extraneous_files     = total_files - (source_media.size + target_media.size + shared_media.size)
				total_file_size      = analysis['size']
				extraneous_file_size = total_file_size - size_from_fingerprints(analysis, (source_media + target_media + shared_media))

				output << print_title_value('Unique source media (move to target)',"#{to_files(source_media.size)} => #{to_MB(size_from_fingerprints(analysis, source_media))}")
				output << print_title_value('Unique target media (keep in target)',"#{to_files(target_media.size)} => #{to_MB(size_from_fingerprints(analysis, target_media))}")
				output << print_title_value('Shared target media (remove from source)',"#{to_files(shared_media.size)} => #{to_MB(size_from_fingerprints(analysis, shared_media))}")
				output << print_title_value('Extraneous media (remove from target and source)',"#{to_files(extraneous_files)} => #{to_MB(extraneous_file_size)}")
			end

			def self.print_analysis_details(analysis, output)
				output << print_header('Analysis Details')

				source_media, target_media, shared_media = classify_media(analysis)

				output << print_sub_header('Unique Source Media')
				details_from_fingerprints(analysis, source_media).each do |details|
					output << "#{details['path']}\n"
				end

				output << print_sub_header('Unique Target Media')
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

			def self.print_header(header)
				header = "\n#{header}\n".color(:green)
				header << "-----------------------------------------\n"
				header
			end

			def self.print_sub_header(sub_header)
				sub_header = "\n#{sub_header}\n".color(:blue)
				sub_header << "-------------------\n"
				sub_header
			end

			def self.print_title_value(title,value)
				"#{title.color(:magenta)}: #{value}\n"
			end

			def self.in_dir_tree?(path, dirs)
				dirs.each do |dir|
					return true if path =~ /#{dir}/
				end
				false
			end

			def self.size_from_fingerprints(analysis, fingerprints)
				fingerprints.inject(0) do |total_size, fingerprint|
					next unless fingerprint = analysis['unique_media'][fingerprint]
					total_size += fingerprint['size']
				end
			end

			def self.details_from_fingerprints(analysis, fingerprints)
				unique_media = analysis['unique_media']
				fingerprints.map do |fingerprint|
					media_files_details = unique_media[fingerprint]['media_files']
					{'path' => media_files_details.first['path']}
				end
			end
  	end
  end
end