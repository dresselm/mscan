require 'spec_helper'

describe Mscan::Meta::ScanFile do

  context "path_to_meta_file" do
    it "should point to scan.mscan" do
      Mscan::Meta::ScanFile.path_to_meta_file('blah').should == "blah/scan.mscan"
    end
  end

end
