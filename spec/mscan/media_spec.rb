require 'spec_helper'

describe Mscan::Media do

  it 'should expose the full path' do
    path = 'spec/media/photos/pngs/file1.png'
    Mscan::Media.new(path).path.should == path
  end

  it 'should expose the file name' do
    path = 'spec/media/photos/pngs/file1.png'
    Mscan::Media.new(path).name.should == 'file1.png'
  end

  it 'should expose the file type' do
    path = 'spec/media/photos/pngs/file1.png'
    Mscan::Media.new(path).type.should == Mscan::MediaType::PNG
  end

  context 'to_params' do
    it 'should include the created_at' do
      media = Mscan::Media.new('.')
      media.stub(:fingerprint).and_return('fingerprint')
      media.should_receive(:created_at).and_return('created_at')
      media.to_params.should include(:created_at => 'created_at')
    end

    it 'should include the modified_at' do
      media = Mscan::Media.new('.')
      media.stub(:fingerprint).and_return('fingerprint')
      media.should_receive(:modified_at).and_return('modified_at')
      media.to_params.should include(:modified_at => 'modified_at')
    end

    it 'should include the size' do
      media = Mscan::Media.new('.')
      media.stub(:fingerprint).and_return('fingerprint')
      media.should_receive(:size).and_return('size')
      media.to_params.should include(:size => 'size')
    end

    it 'should support optional params' do
      media = Mscan::Media.new('.')
      media.should_receive(:fingerprint).and_return('fingerprint')
      media.should_receive(:absolute_path).and_return('absolute_path')

      params = media.to_params(:fingerprint, :absolute_path)
      params.should include(:fingerprint => 'fingerprint')
      params.should include(:absolute_path => 'absolute_path')
    end
  end

  context 'fingerprint' do
    let(:pngs_path) { 'spec/media/photos/pngs' }
    let(:file1) { Mscan::Media.new("#{pngs_path}/file1.png") }

    it 'should return the same value for the same file' do
      file1.fingerprint.should == file1.fingerprint
    end

    it 'should return the same value for the same file having different names' do
      file1_diff_name = Mscan::Media.new("#{pngs_path}/file1_diff_name.png")
      file1.fingerprint.should == file1_diff_name.fingerprint
    end

    it 'should return a different value for different files' do
      file2 = Mscan::Media.new("#{pngs_path}/file2.png")
      file1.fingerprint.should_not == file2.fingerprint
    end

    it 'should return a different value for an altered version of the original' do
      file1_altered = Mscan::Media.new("#{pngs_path}/file1_altered.png")
      file1.fingerprint.should_not == file1_altered.fingerprint
    end
  end

  context 'valid?' do
    let(:pngs_path) { 'spec/media/photos/pngs' }

    it 'should return false for directories' do
      Mscan::Media.valid?(pngs_path).should be_false
    end

    it 'should return false for an invalid MediaType' do
      expected_file_path = "#{pngs_path}/file1.png"
      Mscan::MediaType.should_receive(:valid?).with(expected_file_path).and_return(false)

      Mscan::Media.valid?(expected_file_path).should be_false
    end

    it 'should return true for a valid MediaType file' do
      expected_file_path = "#{pngs_path}/file1.png"
      Mscan::MediaType.should_receive(:valid?).with(expected_file_path).and_return(true)

      Mscan::Media.valid?(expected_file_path).should be_true
    end
  end

end