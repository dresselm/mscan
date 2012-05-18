require 'spec_helper'

describe Mscan::AnalysisFile do

  context "path_to_meta_file" do
    it "should point to analysis.mscan" do
      Mscan::AnalysisFile.path_to_meta_file('blah').should == "blah/analysis.mscan"
    end
  end

end
