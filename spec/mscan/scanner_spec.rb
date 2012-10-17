require 'spec_helper'

# TODO figure out how to use FakeFS such that it mirrors the actual
# spec/media directory
# possibly save a flat rb file that contains a serialized representation
# of the data that can then be used to create a temp structure via FakeFS
describe Mscan::Scanner do

  after do
    # Remove all the spec-produced meta.mscan files
    Dir.glob('spec/media/**/meta.mscan') do |meta_mscan_path|
      File.delete(meta_mscan_path)
    end
    # Remove the ANALYSIS_OUTPUT_DIR
  end

  describe '.scan' do
    it 'should scan all configured media directories' do
      Mscan::MediaDir.should_receive(:find_all_media_dirs).and_return([])
      Mscan::Scanner.scan
    end

    context 'when scanning each originating directory' do
      let(:spec_media_dir) { 'spec/media/**/*' }

      before do
        Mscan::Scanner.scan
      end

      it 'should save a meta data file' do
        Dir.glob(spec_media_dir).each do |expected_scan_directory|
          next if !File.directory?(expected_scan_directory)

          mscan_file = "#{expected_scan_directory}/meta.mscan"
          File.exist?(mscan_file).should be_true
        end
      end

      it 'should include a meta data update timestamp'
      # puts Yajl::Parser.new.parse(File.read(mscan_file))
      it 'should include details for every media file'
      it 'should include details for unknown file types'
    end

    context 'when constructing the composite data' do
      it 'should aggregate all the meta data'
      it 'should provide the full path to each originating file'

      it 'should save the composite data to the ANALYSIS_OUTPUT_DIR' do
        Mscan::Scanner.scan

        expected_composite_file = "#{Mscan::Store::ANALYSIS_OUTPUT_DIR}/#{Time.now.to_i}_scan.mscan"
        File.size?(expected_composite_file).should_not be_nil
      end

    end

  end

end