require 'spec_helper'

describe Mscan::Scanner do

  before do
    @now = Time.now
    Timecop.freeze(@now)
    FakeFS.activate!
    MediaBuilder.build
  end

  after do
    FakeFS.deactivate!
    FakeFS::FileSystem.clear
    Timecop.return
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
          mscan_obj  = Yajl::Parser.parse(File.read(mscan_file))
          mscan_obj['timestamp'].should_not be_nil
        end
      end

      it 'should include details for every media file' do
        MediaBuilder.directories.each do |dir|
          mscan_file = "#{dir}/meta.mscan"
          mscan_obj  = Yajl::Parser.parse(File.read(mscan_file))

          expected_files = Mscan::MediaDir.new(dir).media.map(&:name)
          mscan_obj['media_files'].map {|mf| mf['name'] }.should =~ expected_files
        end
      end
    end

    context 'when constructing the composite data' do
      before do
        Mscan::Scanner.scan

        @timestamped_composite_file = "scans/#{Time.now.to_i}_scan.mscan"
      end

      it 'should timestamp the file' do
        File.exist?(@timestamped_composite_file).should be_true
      end

      it 'should provide the full path to each originating directory' do
        mscan_composite_obj = Yajl::Parser.parse(File.read(@timestamped_composite_file))
        MediaBuilder.directories.each do |dir|
          expected_full_path = File.expand_path(dir)
          mscan_composite_obj[expected_full_path].should_not be_nil
        end
      end

      it 'should aggregate all the meta data' do
        mscan_composite_obj = Yajl::Parser.parse(File.read(@timestamped_composite_file))
        expected_file_paths = MediaBuilder.files.keys.map { |f| File.expand_path(f) }

        MediaBuilder.directories.each do |dir|
          expected_full_path = File.expand_path(dir)
          originating_dir_meta_data = mscan_composite_obj[expected_full_path]
          media_files = originating_dir_meta_data['media_files'].map {|f| f['name']}
          media_files.each do |media_file|
            media_file_path = "#{expected_full_path}/#{media_file}"
            expected_file_paths.should include(media_file_path)
            # remove the current path from the expected list
            expected_file_paths -= [media_file_path]
          end
        end
        # The only file that should remain is the unknown media
        expected_file_paths.should == [File.expand_path('spec/media/target/dirC/unknown.u')]
      end
    end
  end
end