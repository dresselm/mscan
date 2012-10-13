require 'spec_helper'

describe Mscan::MediaFileType do

  describe "valid?" do
    it 'should return true for a valid file type' do
      Mscan::MediaFileType.valid?('some_file.png').should be_true
    end

    it 'should return false for an invalid file type' do
      Mscan::MediaFileType.valid?('some_file.invalid_type').should be_false
    end

    it 'should be case insensitive' do
      Mscan::MediaFileType.valid?('some_file.PnG').should be_true
    end
  end

  describe "archive?" do
    it 'should return true for an archive' do
      Mscan::MediaFileType.archive?('some_file.tar').should be_true
    end

    it 'should return false for a non-archive' do
      Mscan::MediaFileType.archive?('some_file.png').should be_false
    end
  end

  describe "temp?" do
    it 'should return true for a temp file' do
      Mscan::MediaFileType.temp?('some_file.bak').should be_true
    end

    it 'should return false for a non-temp file' do
      Mscan::MediaFileType.temp?('some_file.png').should be_false
    end
  end

  describe "for_file_name" do
    it 'should return nil if the file name does not contain a period' do
      Mscan::MediaFileType.for_file_name('blah').should be_nil
    end

    it 'should return nil if the file type is not supported' do
      Mscan::MediaFileType.for_file_name('blah.blah').should be_nil
    end

    it 'should return the correct MediaFileType for a given file name' do
      Mscan::MediaFileType.for_file_name('blah.png').should == Mscan::MediaFileType::PNG
    end
  end
end