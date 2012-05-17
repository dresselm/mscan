require 'spec_helper'

describe Mscan::MediaDir do

  it 'should expose path' do
    Mscan::MediaDir.new('/some_path').path.should == '/some_path'
  end

  context 'entities' do
    it 'should return all files and directories within the given directory' do
      md = Mscan::MediaDir.new('spec/media')
      md.entities.should =~ [".", "..", "empty", "audio", "photo", "unknown.medium", "video"]
    end
  end

  context 'media' do
    it 'should return empty if there is no valid Media in the directory' do
      md = Mscan::MediaDir.new('spec/media/empty')
      md.media.should be_empty
    end

    it 'should return all valid Media for the given directory' do
      md = Mscan::MediaDir.new('spec/media/photo/pngs')
      media = md.media
      media.should_not be_empty
      media.each do |medium|
        medium.class.should == Mscan::Medium
        medium.type.should  == Mscan::MediumType::PNG
      end
    end
  end

  context 'to_params' do
    it 'should test something'
  end

  context 'find_media_dirs' do
    it 'should raise an InvalidPathError if the given path is not a valid directory' do
      expect {
          Mscan::MediaDir.find_media_dirs('spec/invalid_path')
        }.to raise_error(Mscan::MediaDir::InvalidPathError)
    end

    it 'should return the list of Mscan::MediaDirs for a given path' do
      media_dirs = Mscan::MediaDir.find_media_dirs('spec/media')

      media_dirs.should_not be_empty
      media_dirs.map(&:path).should =~ ['spec/media',
                                        'spec/media/empty',
                                        'spec/media/photo',
                                        'spec/media/photo/jpgs',
                                        'spec/media/photo/pngs',
                                        'spec/media/video',
                                        'spec/media/audio']
    end
  end

end