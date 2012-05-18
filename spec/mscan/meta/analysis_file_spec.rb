require 'spec_helper'

describe Mscan::Meta::AnalysisFile do

  context "path_to_meta_file" do
    it "should point to analysis.mscan" do
      Mscan::Meta::AnalysisFile.path_to_meta_file('blah').should == "blah/analysis.mscan"
    end
  end

end
