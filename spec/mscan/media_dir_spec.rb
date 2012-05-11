require 'spec_helper'

describe Mscan::MediaDir do

  describe 'find_media_dirs' do
    it 'should return the list of Mscan::MediaDirs for a given path' do
      media_dirs = Mscan::MediaDir.find_media_dirs('spec/media')

      media_dirs.should_not be_empty
      media_dirs.map(&:path).should =~ ['spec/media',
                                        'spec/media/photos',
                                        'spec/media/photos/jpgs',
                                        'spec/media/photos/pngs',
                                        'spec/media/videos']
    end
  end

end