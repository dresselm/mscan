class MediaBuilder
  BASE_DIR = 'spec/media'

  DEFAULT_DIRS = {
    :source => [:dir1, :dir2, :dir3, :emptyDir],
    :target => [:dirA, :dirB, :dirC]
  }

  DEFAULT_FILES = {
    'file1.png'     => {:dirs => [File.join('source', 'dir1'),
                                  File.join('target', 'dirC')], :content => 'file 1 content'},
    'file2.png'     => {:dirs => [File.join('source', 'dir1'),
                                  File.join('target', 'dirA')], :content => 'file 2 content'},
    'file3.png'     => {:dirs => [File.join('source', 'dir2')], :content => 'file 3 content'},
    'copyFile1.png' => {:dirs => [File.join('source', 'dir3')], :content => 'file 1 content'},
    'file4.png'     => {:dirs => [File.join('source', 'dir3'),
                                  File.join('target', 'dirB')], :content => 'file 4 content'},
    'file5.png'     => {:dirs => [File.join('source', 'dir3')], :content => 'file 5 content'},
    'file6.png'     => {:dirs => [File.join('target', 'dirC')], :content => 'file 6 content'},
    'unknown.u'     => {:dirs => [File.join('target', 'dirC')], :content => 'non media file content'}
  }

  def self.build
    # Build directories
    directories.each do |dir|
      FileUtils.mkdir_p(dir)
    end

    # Build media
    files.each_pair do |full_path, content|
      File.open(full_path, 'w') { |f| f.write(content) }
    end
  end

  def self.directories
    directories = []
    DEFAULT_DIRS.each_pair do |dir, sub_directories|
      full_dir_path = "#{BASE_DIR}/#{dir}"
      sub_directories.each do |sub_dir|
        directories << "#{full_dir_path}/#{sub_dir}"
      end
    end
    directories
  end

  def self.files
    files = {}
    DEFAULT_FILES.each_pair do |key, metadata|
      file_name = key
      dirs = metadata[:dirs]
      content = metadata[:content]
      dirs.each do |dir|
        files[File.join(BASE_DIR, dir, file_name)] = content
      end
    end
    files
  end
end

