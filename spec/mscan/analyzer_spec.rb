require 'spec_helper'

describe Mscan::Analyzer do

  describe '.analyze' do
    it 'should load the most recent meta data' do
      Mscan::Analyzer.should_receive(:load_most_recent).with('analysis/scan.mscan')
      Mscan::Analyzer.stub(:save_analysis)
      Mscan::Analyzer.analyze
    end

    it 'should pass the meta data to analyzers' do
      raw_meta_data = {}
      Mscan::Analyzer.stub(:load_most_recent).and_return(raw_meta_data)
      Mscan::Analysis::Redundancy.should_receive(:analyze).with(raw_meta_data)
      Mscan::Analyzer.stub(:save_analysis)

      Mscan::Analyzer.analyze
    end

    it 'should save the analysis' do
      analyzed_meta_data = {}
      Mscan::Analysis::Redundancy.stub(:analyze).and_return(analyzed_meta_data)
      Mscan::Analyzer.should_receive(:save_analysis).with(analyzed_meta_data)

      Mscan::Analyzer.analyze
    end
  end

  describe '.total_size' do
    it 'should return 0 when no media files are passed in' do
      Mscan::Analyzer.total_size([]).should be_zero
    end

    it 'should sum up the sizes of all media files passed in' do
      mf1 = { 'size' => 10 }
      mf2 = { 'size' => 25 }
      Mscan::Analyzer.total_size([mf1, mf2]).should == 35
    end
  end

  describe '.file_count' do
    it 'should return 0 when no media files are passed in' do
      Mscan::Analyzer.file_count({}).should be_zero
    end

    it 'should return the number of media files that are passed in' do
      mf1 = { 'size' => 10 }
      mf2 = { 'size' => 25 }
      meta_data_hash = {:mf1 => mf1, :mf2 => mf2}
      Mscan::Analyzer.file_count(meta_data_hash).should == 2
    end
  end
end