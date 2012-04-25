require 'spec_helper'

describe Mscan::Metadata do
  # TODO rewrite metadata methods to take streams vs paths for easier testing
  context 'write' do
    it "should write the content to the metadata file"
    it "should convert the content to json"
    it "should create an empty file if no content is passed"
    it "should raise an error if the supplied path is invalid"
  end

  context 'read' do
    it "should read content from the supplied file path"
    it "should convert the metadata json to an object"
    it "raise an error if the supplied path is invalid"
  end
end