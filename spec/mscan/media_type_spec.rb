require 'spec_helper'

describe Mscan::MediaType do

  describe "valid?" do
    it 'should return true for a valid file type' do
      Mscan::MediaType.valid?(Mscan::MediaType::PNG).should be_true
    end

    it 'should return false for an invalid file type' do
      Mscan::MediaType.valid?('INVALID TYPE').should be_false
    end

    it 'should support symbols' do
      Mscan::MediaType.valid?(:png).should be_true
    end

    it 'should be case insensitive' do
      Mscan::MediaType.valid?('PnG').should be_true
    end
  end

  describe "for_file_name" do
    it 'should raise a NoExtension error if the file name does not contain a period' do
      expect {
        Mscan::MediaType.for_file_name('blah')
      }.to raise_error(Mscan::MediaType::NoExtension)
    end

    it 'should raise an UnknownType error if the file type is not supported' do
      expect {
        Mscan::MediaType.for_file_name('blah.blah')
      }.to raise_error(Mscan::MediaType::UnknownType)
    end

    it 'should return the correct MediaType for a given file name' do
      Mscan::MediaType.for_file_name('blah.png').should == Mscan::MediaType::PNG
    end
  end

end