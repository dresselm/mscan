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

end