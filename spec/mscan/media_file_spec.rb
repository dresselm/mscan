require 'spec_helper'

describe Mscan::MediaFile do

  let(:file1_path) { 'spec/media/source/dir1/file1.png' }

  before do
    FakeFS.activate!
    MediaBuilder.build
  end

  after do
    FakeFS.deactivate!
    FakeFS::FileSystem.clear
  end

  describe 'attributes' do
    before do
      @media_file = Mscan::MediaFile.new(file1_path)
    end

    it 'should expose the relative path' do
      @media_file.path.should == file1_path
    end

    it 'should expose the absolute path' do
      @media_file.absolute_path.should == "#{Dir.pwd}/#{file1_path}"
    end

    it 'should expose the file name' do
      @media_file.name.should == 'file1.png'
    end

    it 'should expose the file type' do
      @media_file.type.should == Mscan::MediaFileType::PNG
    end
  end

  describe '#to_params' do
    before do
      @media_file = Mscan::MediaFile.new(file1_path)
    end

    it 'should include the modified_at' do
      now = Time.now
      File.should_receive(:mtime).with(file1_path).and_return(now)
      @media_file.to_params[:modified_at].should == now.to_i
    end

    it 'should include the size' do
      @media_file.to_params[:size].should == 14
    end

    it 'should support optional params' do
      params = @media_file.to_params(:fingerprint)
      params[:fingerprint].should == '5ebf967df304e3d9c449e2e210a5f79f'
    end
  end

  describe 'fingerprint' do
    let(:file1)           { Mscan::MediaFile.new(file1_path) }
    let(:file1_diff_path) { Mscan::MediaFile.new('spec/media/target/dirC/file1.png') }
    let(:file1_diff_name) { Mscan::MediaFile.new('spec/media/source/dir3/copyFile1.png') }
    let(:file2)           { Mscan::MediaFile.new('spec/media/source/dir1/file2.png') }
    let(:file1_altered)   { Mscan::MediaFile.new('spec/media/source/dir1/file2.png') }

    it 'should return the same value for the same file' do
      file1.fingerprint.should == file1.fingerprint
    end

    it 'should return the same value for the same file having a different path' do
      file1.fingerprint.should == file1_diff_path.fingerprint
    end

    it 'should return the same value for the same file having a different name' do
      file1.fingerprint.should == file1_diff_name.fingerprint
    end

    it 'should return a different value for different files' do
      file1.fingerprint.should_not == file2.fingerprint
    end
  end

  describe 'valid?' do
    let(:source_path)         { 'spec/media/source' }
    let(:unknown_medium_path) { 'spec/media/target/dirC/unknown.medium' }

    it 'should return false for directories' do
      Mscan::MediaFile.valid?(source_path).should be_false
    end

    it 'should return false for an invalid MediaFileType' do
      Mscan::MediaFile.valid?(unknown_medium_path).should be_false
    end

    it 'should return true for a valid MediaFileType file' do
      Mscan::MediaFile.valid?(file1_path).should be_true
    end
  end

end