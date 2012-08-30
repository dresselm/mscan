require 'spec_helper'

describe Mscan::Analyzer do

  describe '.analyze' do
    it 'should load the most recent meta data'
    it 'should pass the meta data to analyzers'
    it 'should save the analysis'
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