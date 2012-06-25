require 'spec_helper'

describe Mscan::MediaDir do

  it 'should expose path' do
    Mscan::MediaDir.new('/some_path').path.should == '/some_path'
  end

  context '#entities' do
    it 'should return all files and directories within the given directory' do
      md = Mscan::MediaDir.new('spec/media')
      md.entities.should =~ [".", "..", "empty", "audio", "photo", "unknown.medium", "video"]
    end
  end

  context '#media' do
    it 'should return empty if there is no valid Media in the directory' do
      md = Mscan::MediaDir.new('spec/media/empty')
      md.media.should be_empty
    end

    it 'should return all valid Media for the given directory' do
      md = Mscan::MediaDir.new('spec/media/photo/pngs')
      media = md.media
      media.should_not be_empty
      media.each do |media_file|
        media_file.class.should == Mscan::MediaFile
        media_file.type.should  == Mscan::MediaFileType::PNG
      end
    end
  end

  context '#sorted_media' do
    it 'should return an empty array if there is no valid media' do
      md = Mscan::MediaDir.new
      md.should_receive(:media).and_return([])
      md.sorted_media.should be_empty
    end

    it 'should sort media by name' do
      md = Mscan::MediaDir.new
      media_file1 = Mscan::MediaFile.new('/oranges/apples.png')
      media_file2 = Mscan::MediaFile.new('/apples/oranges.png')

      md.should_receive(:media).and_return([media_file1, media_file2])

      md.sorted_media.should =~ [media_file2, media_file1]
    end

  end

  context '#to_params' do
    it 'should return an empty hash if there is no valid media' do
      md = Mscan::MediaDir.new
      md.should_receive(:sorted_media).and_return([])
      md.to_params.should be_empty
    end
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