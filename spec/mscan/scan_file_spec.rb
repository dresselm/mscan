require 'spec_helper'

describe Mscan::ScanFile do

  context "path_to_meta_file" do
    it "should point to scan.mscan" do
      Mscan::ScanFile.path_to_meta_file('blah').should == "blah/scan.mscan"
    end
  end

end
