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
    it 'should include the fingerprint' do
      media = Mscan::Media.new('.')
      media.should_receive(:fingerprint).and_return('fingerprint')
      media.to_params.should include(:fingerprint => 'fingerprint')
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

end