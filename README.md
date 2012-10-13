 [![Build Status](https://secure.travis-ci.org/dresselm/mscan.png)](http://travis-ci.org/dresselm/mscan)

# Mscan

TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'mscan'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mscan


    $ gem uninstall mscan && rake build && gem install pkg/mscan

## Usage

    $ mscan scan -d dir1 -d dir2 -d dir3 (an array of root directories)
    $ mscan analyze (what kind of analysis - all, difference, missing, ) - could default this to :all and run it as a part of report for now
    $ mscan report

## TODO

* Implement the spec/media directory as a 'fixture' for FakeFS
* Add File meta data to Mscan::Media, like mtime, file size
* Add Directory meta data to Mscan::MediaDir like media file count, meta data file, dir size

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
