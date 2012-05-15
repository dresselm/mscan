require 'spec_helper'

describe Mscan::MediumType do

  describe "valid?" do
    it 'should return true for a valid file type' do
      Mscan::MediumType.valid?('some_file.png').should be_true
    end

    it 'should return false for an invalid file type' do
      Mscan::MediumType.valid?('some_file.invalid_type').should be_false
    end

    it 'should be case insensitive' do
      Mscan::MediumType.valid?('some_file.PnG').should be_true
    end
  end

  describe "for_file_name" do
    it 'should return nil if the file name does not contain a period' do
      Mscan::MediumType.for_file_name('blah').should be_nil
    end

    it 'should return nil if the file type is not supported' do
      Mscan::MediumType.for_file_name('blah.blah').should be_nil
    end

    it 'should return the correct MediumType for a given file name' do
      Mscan::MediumType.for_file_name('blah.png').should == Mscan::MediumType::PNG
    end
  end
end