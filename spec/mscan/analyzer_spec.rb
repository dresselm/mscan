require 'spec_helper'
require 'fakefs/spec_helpers'

describe Mscan::Analyzer do
  include FakeFS::SpecHelpers

  let(:raw_meta_data) {
    {
      "some.png"  => {"modified_at" => 1299024957, "size" => 3226, "fingerprint" => "cd5a4d84eb060aef3aeeb9123bb7bb8c"},
      "other.png" => {"modified_at" => 1299024957, "size" => 2998, "fingerprint" => "7ebd9ab20fcfffdf5d64f4efdf3b67a7"}
    }
  }

  before do
    @now = Time.now
    Timecop.freeze(@now)
  end

  after do
    Timecop.return
  end

  describe '.analyze' do
    it 'should load the most recent meta data' do
      Mscan::Analyzer.should_receive(:load_most_recent).with('output/analysis/scan.mscan')

      Mscan::Analyzer.analyze
    end

    it 'should pass the meta data to analyzers' do
      Mscan::Analyzer.stub(:load_most_recent).and_return(raw_meta_data)
      Mscan::Analysis::Redundancy.should_receive(:analyze).with(raw_meta_data)

      Mscan::Analyzer.analyze
    end

    it 'should save the analysis' do
      Mscan::Analyzer.stub(:load_most_recent).and_return(raw_meta_data)

      Mscan::Analyzer.analyze

      File.exist?("analysis/#{@now.to_i}_analysis.mscan")
    end
  end

  describe '.total_size' do
    it 'should return 0 if media files are nil' do
      Mscan::Analyzer.total_size(nil).should be_zero
    end

    it 'should return 0 if media files are empty' do
      Mscan::Analyzer.total_size([]).should be_zero
    end

    it 'should sum up the sizes of all media files passed in' do
      mf1 = { 'size' => 10 }
      mf2 = { 'size' => 25 }
      Mscan::Analyzer.total_size([mf1, mf2]).should == 35
    end
  end

  describe '.file_count' do
    it 'should return 0 if media files are nil' do
      Mscan::Analyzer.file_count(nil).should be_zero
    end

    it 'should return 0 if media files are empty' do
      Mscan::Analyzer.file_count([]).should be_zero
    end

    it 'should return the number of media files that are passed in' do
      mf1 = { 'size' => 10 }
      mf2 = { 'size' => 25 }
      meta_data_hash = {:mf1 => mf1, :mf2 => mf2}
      Mscan::Analyzer.file_count(meta_data_hash).should == 2
    end
  end
end