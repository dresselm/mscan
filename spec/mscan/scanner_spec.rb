require 'spec_helper'

describe Mscan::Scanner do

  before do
    FakeFS.activate!
    MediaBuilder.build
  end

  after do
    FakeFS.deactivate!
    FakeFS::FileSystem.clear
  end

  describe '.scan' do
    it 'should scan all configured media directories' do
      Mscan::MediaDir.should_receive(:find_all_media_dirs).and_return([])
      Mscan::Scanner.scan
    end

    context 'when scanning each originating directory' do
      before do
        Mscan::Scanner.scan
      end

      it 'should save a meta data file' do
        MediaBuilder.directories.each do |dir|
          mscan_file = "#{dir}/meta.mscan"
          File.exist?(mscan_file).should be_true
        end
      end

      it 'should include a meta data update timestamp' do
        MediaBuilder.directories.each do |dir|
          mscan_file = "#{dir}/meta.mscan"
          mscan_obj  = Yajl::Parser.new.parse(File.read(mscan_file))
          mscan_obj['timestamp'].should_not be_nil
        end
      end

      it 'should include details for every media file' do
        MediaBuilder.directories.each do |dir|
          mscan_file = "#{dir}/meta.mscan"
          mscan_obj  = Yajl::Parser.new.parse(File.read(mscan_file))

          expected_files = Mscan::MediaDir.new(dir).media.map(&:name)
          mscan_obj['media_files'].map {|mf| mf['name'] }.should =~ expected_files
        end
      end
    end

    context 'when constructing the composite data' do
      it 'should aggregate all the meta data' do

      end

      it 'should provide the full path to each originating file'

      it 'should save the composite data to the ANALYSIS_OUTPUT_DIR' do
        Mscan::Scanner.scan

        expected_composite_file = "#{Mscan::Store::ANALYSIS_OUTPUT_DIR}/#{Time.now.to_i}_scan.mscan"
        File.size?(expected_composite_file).should_not be_nil
      end

    end

  end

end