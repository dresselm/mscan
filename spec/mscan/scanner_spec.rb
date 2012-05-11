require 'spec_helper'

describe Mscan::Scanner do

  describe 'subdirectories' do
    it 'should return the list of subdirectories for a given path' do
      subdirectories = Mscan::Scanner.subdirectories('spec/media')

      subdirectories.should_not be_empty
      subdirectories.should =~ ['spec/media',
                                'spec/media/photos',
                                'spec/media/photos/jpgs',
                                'spec/media/photos/pngs',
                                'spec/media/videos']
    end
  end
end