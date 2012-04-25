require 'spec_helper'

describe Mscan::Settings do
  it 'should be a singleton' do
    Mscan::Settings.instance.should == Mscan::Settings.instance
  end
end