require 'spec_helper'

describe Mscan::ArchiveMedium do

  context 'to_params' do
    it 'should return params for all archived media' do
      path = 'spec/media/archive.zip'
      Mscan::ArchiveMedium.new(path).to_params.should be_nil
    end
  end

  context 'media' do
    it 'should return all archived media' do
      path = 'spec/media/archive.zip'
      archived_media = Mscan::ArchiveMedium.new(path).media
      archived_media.should_not be_empty
    end
  end

end