require 'spec_helper'
require 'fakefs/spec_helpers'

describe Mscan::Scanner do
  include FakeFS::SpecHelpers

  def create_test_files_within(dir_list)
    dir_list.each_with_index do |directory, index|
      FileUtils.mkdir_p(directory)
      FileUtils.cd(directory) do
        File.open("test#{index}.png", 'w+') do |f|
          f.puts "some gibberish #{index}"
        end
      end
    end
  end

  before do
    @now = Time.now
    Timecop.freeze(@now)

    @scan_directories = Mscan::Config.scan_directories
    create_test_files_within(@scan_directories)
  end

  after do
    Timecop.return
  end

  context '.scan' do
    it 'should search all configured media directories' do
      Mscan::MediaDir.should_receive(:find_all_media_dirs).and_return([])
      Mscan::Scanner.scan
    end

    context 'meta data files' do
      it 'should construct meta data files by delegating to MediaDir' do
        expected_path = '/path'
        expected_content = {:content => true}
        Mscan::MediaDir.any_instance.should_receive(:path).and_return(expected_path)
        Mscan::MediaDir.any_instance.should_receive(:to_params).with(:fingerprint).and_return(expected_content)
        Mscan::Scanner.should_receive(:save).with("#{expected_path}/#{Mscan::Store::META_FILE_NAME}", expected_content)
        Mscan::Scanner.stub(:save_composite_scan_data)

        Mscan::Scanner.scan
      end

      it 'should save a meta data file within each originating directory' do
        Mscan::Scanner.scan

        @scan_directories.each do |scan_directory|
          FileUtils.cd(scan_directory) do
            File.size?('meta.mscan').should_not be_nil
          end
        end
      end
    end

    context 'composite file' do
      it 'should construct the composite scan file by aggregating all meta data'
      it 'should provide the full path to each originating file'

      it 'should save the composite scan data to the ANALYSIS_OUTPUT_DIR' do
        Mscan::Scanner.scan

        expected_composite_file = "#{Mscan::Store::ANALYSIS_OUTPUT_DIR}/#{Time.now.to_i}_scan.mscan"
        File.size?(expected_composite_file).should_not be_nil
      end
    end

  end

end