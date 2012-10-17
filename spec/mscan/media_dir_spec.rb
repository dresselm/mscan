require 'spec_helper'

describe Mscan::MediaDir do

  let(:empty_dir_path) { 'spec/media/source/emptyDir' }

  it 'should expose path' do
    Mscan::MediaDir.new('/some_path').path.should == '/some_path'
  end

  context '#entities' do
    it 'should return all files and directories within the given directory' do
      md = Mscan::MediaDir.new('spec/media')
      md.entities.should =~ [".", "..", "source", "target"]
    end
  end

  context '#media' do
    it 'should return empty if there is no valid Media in the directory' do
      md = Mscan::MediaDir.new(empty_dir_path)
      md.media.should be_empty
    end

    it 'should return all valid Media for the given directory' do
      md = Mscan::MediaDir.new('spec/media/source/dir1')
      media = md.media
      media.should_not be_empty
      media.size.should == 2
      media.map(&:name).should =~ ['file1.png', 'file2.png']
      media.map(&:type).should =~ [Mscan::MediaFileType::PNG,Mscan::MediaFileType::PNG]
    end
  end

  context '#sorted_media' do
    it 'should return an empty array if there is no valid media' do
      md = Mscan::MediaDir.new(empty_dir_path)
      md.sorted_media.should be_empty
    end

    it 'should sort media by name' do
      md = Mscan::MediaDir.new
      media_file1 = Mscan::MediaFile.new('/apples/oranges.png')
      media_file2 = Mscan::MediaFile.new('/oranges/apples.png')
      media_file3 = Mscan::MediaFile.new('/apples/apples.png')

      md.should_receive(:media).and_return([media_file1, media_file2, media_file3])

      md.sorted_media.should == [media_file3, media_file1, media_file2]
    end

  end

  context '#to_params' do
    it 'should return an empty hash if there is no valid media' do
      md = Mscan::MediaDir.new(empty_dir_path)
      md.to_params.should be_empty
    end
  end

  context '.find_all_media_dirs' do
    it 'should return the list of all configured source and target Mscan::MediaDirs' do
      media_dirs = Mscan::MediaDir.find_all_media_dirs

      media_dirs.should_not be_empty
      media_dirs.all?{ |md| md.class == Mscan::MediaDir}.should be_true
      expected_relative_paths = ['spec/media/source',
                                 'spec/media/source/dir1',
                                 'spec/media/source/dir2',
                                 'spec/media/source/dir3',
                                 'spec/media/source/emptyDir',
                                 'spec/media/target',
                                 'spec/media/target/dirA',
                                 'spec/media/target/dirB',
                                 'spec/media/target/dirC']
      # map expected relative paths to expected absolute paths
      media_dirs.map(&:path).should =~ expected_relative_paths.map { |p| Dir.pwd + '/' + p }
    end
  end

  context '.find_media_dirs' do
    it 'should raise an InvalidPathError if the given path is not a valid directory' do
      expect {
          Mscan::MediaDir.find_media_dirs('spec/invalid_path')
        }.to raise_error(Mscan::MediaDir::InvalidPathError)
    end

    it 'should return the list of Mscan::MediaDirs for a given path' do
      media_dirs = Mscan::MediaDir.find_media_dirs('spec/media/source')

      media_dirs.should_not be_empty
      media_dirs.all?{ |md| md.class == Mscan::MediaDir}.should be_true
      media_dirs.map(&:path).should =~ ['spec/media/source',
                                        'spec/media/source/dir1',
                                        'spec/media/source/dir2',
                                        'spec/media/source/dir3',
                                        'spec/media/source/emptyDir']
    end
  end

end