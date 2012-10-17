require 'spec_helper'
require 'fakefs'


# TODO write much better specs
describe Mscan::Scanner do

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
    # TODO use real files as inputs but FakeFS for the output
    # call the spec helper:
    # Possibly in the spec_helper create a function that is run before_all
    # and exposes the spec/media data, so that the FakeFS helper can replicate it
    @scan_directories = Mscan::Config.scan_directories
    create_test_files_within(@scan_directories)
  end

  describe '.scan' do
    it 'should scan all configured media directories' do
      Mscan::MediaDir.should_receive(:find_all_media_dirs).and_return([])
      Mscan::Scanner.scan
    end

    context 'when scanning each originating directory' do

      it 'should save a meta data file' do
        Mscan::Scanner.scan

        @scan_directories.each do |scan_directory|
          # puts scan_directory
          FileUtils.cd(scan_directory) do
            File.exist?('meta.mscan').should be_true
            mscan_object = Yajl::Parser.new.parse(File.read('meta.mscan'))
            # puts mscan_object.values
            # .should == '{"test0.png":{"modified_at":1350455513,"size":17,"fingerprint":"a2cdb7a6dcdcdf1a4a244ba318b737ce"}}'
          end
        end
      end


    end

    it 'should construct the composite scan file by aggregating all meta data'
    it 'should provide the full path to each originating file'

    it 'should save the composite scan data to the ANALYSIS_OUTPUT_DIR' do
      Mscan::Scanner.scan

      expected_composite_file = "#{Mscan::Store::ANALYSIS_OUTPUT_DIR}/#{Time.now.to_i}_scan.mscan"
      File.size?(expected_composite_file).should_not be_nil
    end

  end

end