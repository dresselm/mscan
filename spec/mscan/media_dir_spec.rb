require 'spec_helper'

describe Mscan::MediaDir do

  let(:empty_dir_path) { 'spec/media/source/emptyDir' }
  let(:source_dir1)    { 'spec/media/source/dir1' }

  before do
    FakeFS.activate!
    MediaBuilder.build
  end

  after do
    FakeFS.deactivate!
    FakeFS::FileSystem.clear
  end

  it 'should expose path' do
    Mscan::MediaDir.new('/some_path').path.should == '/some_path'
  end

  describe '#entities' do
    it 'should return all files and directories within the given directory' do
      md = Mscan::MediaDir.new('spec/media')
      md.entities.should =~ [".", "..", "source", "target"]
    end
  end

  describe '#media' do
    context 'when no valid media' do
      it 'should return an empty array' do
        md = Mscan::MediaDir.new(empty_dir_path)
        md.media.should be_empty
      end
    end

    context 'when valid media exists in the given directory' do
      it 'should return an array of media' do
        md = Mscan::MediaDir.new(source_dir1)
        media = md.media
        media.should_not be_empty
        media.size.should == 2
        media.map(&:name).should =~ ['file1.png', 'file2.png']
        media.map(&:type).should =~ [Mscan::MediaFileType::PNG,Mscan::MediaFileType::PNG]
      end
    end
  end

  describe '#sorted_media' do
    context 'when no valid media' do
      it 'should return an empty array' do
        md = Mscan::MediaDir.new(empty_dir_path)
        md.sorted_media.should be_empty
      end
    end

    context 'when valid media' do
      it 'should an array of media sorted by name' do
        md = Mscan::MediaDir.new
        media_file1 = Mscan::MediaFile.new('/apples/oranges.png')
        media_file2 = Mscan::MediaFile.new('/oranges/apples.png')
        media_file3 = Mscan::MediaFile.new('/apples/apples.png')

        md.should_receive(:media).and_return([media_file1, media_file2, media_file3])

        md.sorted_media.should == [media_file3, media_file1, media_file2]
      end
    end
  end

  describe '#to_params' do
    context 'when no valid media' do
      it 'should return just a timestamp' do
        md = Mscan::MediaDir.new(empty_dir_path)
        params_hash = md.to_params
        params_hash[:timestamp].should_not be_nil
        params_hash[:media_files].should be_empty
      end
    end

    context 'when valid media exists in the given directory' do
      it 'should return an array of media' do
        md = Mscan::MediaDir.new(source_dir1)
        params_hash = md.to_params
        params_hash[:timestamp].should_not be_nil
        media_files = params_hash[:media_files]
        media_files.should_not be_empty
        media_files.map {|mf| mf[:name] }.should =~ ['file1.png', 'file2.png']
      end
    end
  end

  describe '.find_all_media_dirs' do
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

  describe '.find_media_dirs' do
    it 'should raise an InvalidPathError if the given path is not a valid directory' do
      expect {
          Mscan::MediaDir.find_media_dirs('spec/invalid_path')
        }.to raise_error(Mscan::MediaDir::InvalidPathError)
    end

    it 'should return the list of Mscan::MediaDirs for a given path' do
      media_dirs = Mscan::MediaDir.find_media_dirs(Dir.pwd + '/spec/media/source')

      media_dirs.should_not be_empty
      media_dirs.all?{ |md| md.class == Mscan::MediaDir}.should be_true
      expected_relative_paths = ['spec/media/source',
                                 'spec/media/source/dir1',
                                 'spec/media/source/dir2',
                                 'spec/media/source/dir3',
                                 'spec/media/source/emptyDir']
      # map expected relative paths to expected absolute paths
      media_dirs.map(&:path).should =~ expected_relative_paths.map { |p| Dir.pwd + '/' + p }
    end
  end

end