require 'spec_helper'

describe Mscan::Analysis::Redundancy do
  let(:raw_data) { {:raw_data => true} }
  let(:transformed_data) { {:transformed_data => true} }
  let(:raw_scan_data) {
    {
      "some_path/file1.png" => {"modified_at" => 1299024957,"size" => 3226,"fingerprint" => "cd5a4d84eb060aef3aeeb9123bb7bb8c"},
      "some_path/file2.png" => {"modified_at" => 1299024957,"size" => 2998,"fingerprint" => "7ebd9ab20fcfffdf5d64f4efdf3b67a7"},
      # duplicate of file1.png
      "some_different_path/fileA.png" => {"modified_at" => 2299024957,"size" => 3226,"fingerprint" => "cd5a4d84eb060aef3aeeb9123bb7bb8c"},
      "some_different_path/fileB.png" => {"modified_at" => 2299024957,"size" => 1234,"fingerprint" => "98194dajkhasdhkf3aeeb0q9ew09q08d"}
    }
  }

  context 'initialize' do
    it 'should set raw data' do
      redundancy = Mscan::Analysis::Redundancy.new(raw_data, nil)
      redundancy.raw_data.should == raw_data
    end

    it 'should set transformed data' do
      redundancy = Mscan::Analysis::Redundancy.new(nil, transformed_data)
      redundancy.transformed_data.should == transformed_data
    end
  end

  context 'analyze' do
    it 'should transform raw data' do
      Mscan::Analysis::Redundancy.should_receive(:transform).with(raw_data).and_return(transformed_data)
      Mscan::Analysis::Redundancy.analyze(raw_data)
    end

    it 'should return a new redunancy analysis object' do
      Mscan::Analysis::Redundancy.stub(:transform).and_return(transformed_data)
      redundancy_analysis = Mscan::Analysis::Redundancy.analyze(raw_data)
      redundancy_analysis.should be_a(Mscan::Analysis::Redundancy)
      redundancy_analysis.raw_data.should == raw_data
      redundancy_analysis.transformed_data.should == transformed_data
    end
  end

  context 'transform' do
    it 'should reindex raw data by fingerprint' do
      transformed_data = Mscan::Analysis::Redundancy.transform(raw_scan_data)
      fingerprints = transformed_data.keys
      fingerprints.size.should == 3
      fingerprints.should =~ ['cd5a4d84eb060aef3aeeb9123bb7bb8c','7ebd9ab20fcfffdf5d64f4efdf3b67a7','98194dajkhasdhkf3aeeb0q9ew09q08d']
    end

    it 'should append duplicate paths for a given fingerprint' do
      transformed_data = Mscan::Analysis::Redundancy.transform(raw_scan_data)
      duplicate_fingerprints = transformed_data['cd5a4d84eb060aef3aeeb9123bb7bb8c']['media']
      duplicate_fingerprints.size.should == 2
      duplicate_fingerprints.map { |fp| fp['path'] }.should =~ ["some_path/file1.png", "some_different_path/fileA.png"]
    end

    it 'should return an empty hash if the scan data is empty' do
      Mscan::Analysis::Redundancy.transform({}).should be_empty
    end

    it 'should return an empty hash if called without parameters' do
      Mscan::Analysis::Redundancy.transform.should be_empty
    end

  end

  context 'to_params' do
    before do
      @analysis = Mscan::Analysis::Redundancy.analyze(raw_scan_data)
      @analysis_params = @analysis.to_params
    end

    # This will not always be the current target scan directories
    it 'should return the scan source directories that the analysis is based on' do
      @analysis_params[:source_dirs].should == Mscan::Config.source_directories
    end

    # This will not always be the current target scan directories
    it 'should return the scan target directories that the analysis is based on' do
      @analysis_params[:target_dirs].should == Mscan::Config.target_directories
    end

    it 'should return the total size of all scanned files' do
      @analysis_params[:size].should == 3226 + 2998 + 3226 + 1234
    end

    it 'should return the total number of scanned files' do
      @analysis_params[:num_files].should == 4
    end

    it 'should return the size of unique files' do
      @analysis_params[:unique_size].should == 3226 + 2998 + 1234
    end

    it 'should return the number of unique files' do
      @analysis_params[:num_unique_files].should == 3
    end

    it 'should return the number of duplicate files' do
      @analysis_params[:num_duplicate_files].should == 1
    end

    it 'should return the transformed data via unique media' do
      @analysis_params[:unique_media].should == @analysis.transformed_data
    end

  end
end