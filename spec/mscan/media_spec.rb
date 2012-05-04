require 'spec_helper'

describe Mscan::Media do

  context 'checksum' do
    let(:file1) { Mscan::Media.new('spec/media/file1.png') }
    let(:file1_diff_name) { Mscan::Media.new('spec/media/file1_diff_name.png') }
    let(:file1_altered) { Mscan::Media.new('spec/media/file1_altered.png') }
    let(:file2) { Mscan::Media.new('spec/media/file2.png') }

    it 'should return the same value for the same file' do
      file1.checksum.should == file1.checksum
    end

    it 'should return the same value for the same file having different names' do
      file1.checksum.should == file1_diff_name.checksum
    end

    it 'should return a different value for different files' do
      file1.checksum.should_not == file2.checksum
    end

    it 'should return a different value for an altered version of the original' do
      file1.checksum.should_not == file1_altered.checksum
    end
  end

end