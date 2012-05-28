require 'spec_helper'
require 'fakefs/spec_helpers'

module Mscan
  class DummyStore
    include Store
  end
end

describe Mscan::Store do
  include FakeFS::SpecHelpers

  before do
    @now = Time.now
    Timecop.freeze(@now)
  end

  after do
    Timecop.return
  end

  # TODO make sure we have similar tests
  # it "should point to analysis.mscan" do
  #   Mscan::Analysis::MetaFile.path_to_meta_file('blah').should == "blah/analysis.mscan"
  # end
  # it "should point to scan.mscan" do
  #   Mscan::Meta::ScanFile.path_to_meta_file('blah').should == "blah/scan.mscan"
  # end

  context 'save' do
    it "should save the content to the metadata file" do
      Mscan::DummyStore.save('some_path/dummy_store.mscan', {:body => 'some string'})

      File.exist?('some_path/dummy_store.mscan').should be_true
    end

    it "should convert the content to json" do
      Mscan::DummyStore.save('some_path/dummy_store.mscan', {:body => 'some string'})

      actual_string = File.open('some_path/dummy_store.mscan', "rb").read
      actual_string.should == "{\"body\":\"some string\"}\n"
    end

    it "should create an empty file if no content is passed" do
      Mscan::DummyStore.save('some_path/dummy_store.mscan')

      actual_string = File.open('some_path/dummy_store.mscan', "rb").read
      actual_string.should == "{}\n"
    end
  end

  context 'load' do
    before do
      FileUtils.mkdir_p('some_path')
      File.open('some_path/dummy_store.mscan', 'w+') do |f|
        f.puts("{\"body\":\"some string\"}\n")
      end
    end

    it "should load content from the supplied file path" do
      Mscan::DummyStore.load('some_path/dummy_store.mscan').should_not be_empty
    end

    it "should convert the metadata json to an object" do
      actual_obj = Mscan::DummyStore.load('some_path/dummy_store.mscan')
      actual_obj.should == {"body" => "some string"}
    end

    it "should raise an InvalidPathError if the supplied path is invalid" do
      expect {
        Mscan::DummyStore.load('some_invalid_path')
      }.to raise_error(Mscan::DummyStore::InvalidPathError)
    end
  end

  context 'load most recent' do
    it 'should return the most recent timestamped file given a file path' do
      FileUtils.mkdir_p('some_path')
      timestamp = Time.now.to_i
      File.open("some_path/#{timestamp + 1000}_dummy_store.mscan", 'w+') do |f|
        f.puts("{\"body\":\"the file with the most recent timestamp\"}\n")
      end

      File.open("some_path/#{timestamp}_dummy_store.mscan", 'w+') do |f|
        f.puts("{\"body\":\"the file with the less recent timestamp\"}\n")
      end

      File.open("some_path/dummy_store.mscan", 'w+') do |f|
        f.puts("{\"body\":\"the file with no timestamp\"}\n")
      end

      Mscan::DummyStore.load_most_recent('some_path/dummy_store.mscan').should == {"body"=>"the file with the most recent timestamp"}
    end

    it 'should return a non-timestamped file when there are no timestamped files' do
      FileUtils.mkdir_p('some_path')
      File.open("some_path/dummy_store.mscan", 'w+') do |f|
        f.puts("{\"body\":\"the file with no timestamp\"}\n")
      end

      Mscan::DummyStore.load_most_recent('some_path/dummy_store.mscan').should == {"body"=>"the file with no timestamp"}
    end

    it 'should raise an InvalidPathError if the supplied path is invalid' do
      expect {
        Mscan::DummyStore.load_most_recent('some_path/dummy_store.mscan')
      }.to raise_error(Mscan::DummyStore::InvalidPathError)
    end
  end

end