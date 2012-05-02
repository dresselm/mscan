require 'spec_helper'
require 'fakefs'

describe Mscan::Metadata do
  before do
    FakeFS.activate!
  end

  after do
    FakeFS.deactivate!
  end

  context 'write' do
    it "should write the content to the metadata file" do
      Mscan::Metadata.write('some_path', {:body => 'some string'})

      File.exist?('some_path/meta.mscan').should be_true
    end

    it "should convert the content to json" do
      Mscan::Metadata.write('some_path', {:body => 'some string'})

      actual_string = File.open('some_path/meta.mscan', "rb").read
      actual_string.should == "{\"body\":\"some string\"}\n"
    end

    it "should create an empty file if no content is passed" do
      Mscan::Metadata.write('some_path')

      actual_string = File.open('some_path/meta.mscan', "rb").read
      actual_string.should == "{}\n"
    end
  end

  context 'read' do
    before do
      FileUtils.mkdir_p('some_path')
      File.open('some_path/meta.mscan', 'w+') do |f|
        f.puts("{\"body\":\"some string\"}\n")
      end
    end

    it "should read content from the supplied file path" do
      Mscan::Metadata.read('some_path').should_not be_empty
    end

    it "should convert the metadata json to an object" do
      actual_obj = Mscan::Metadata.read('some_path')
      actual_obj.should == {"body" => "some string"}
    end

    it "should raise an InvalidPathError if the supplied path is invalid" do
      expect {
        Mscan::Metadata.read('some_invalid_path')
      }.to raise_error(Mscan::Metadata::InvalidPathError)
    end
  end
end