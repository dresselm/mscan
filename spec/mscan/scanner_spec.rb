require 'spec_helper'

describe Mscan::Scanner do

  context 'scan' do
    it 'should search all configured scan directories for media' do
      expected_scan_directories = ['scan directory']
      Mscan::Settings.should_receive(:scan_directories).and_return(expected_scan_directories)
      Mscan::MediaDir.should_receive(:find_media_dirs).with(expected_scan_directories.first).and_return([])

      Mscan::Scanner.scan
    end

    it 'should scan' do
      # Mscan::Scanner.scan
    end

  end

end