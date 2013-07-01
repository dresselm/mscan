Mscan [![Build Status](https://secure.travis-ci.org/dresselm/mscan.png)](http://travis-ci.org/dresselm/mscan) [![Coverage Status](https://coveralls.io/repos/dresselm/mscan/badge.png?branch=master)](https://coveralls.io/r/dresselm/mscan?branch=master) [![Code Climate](https://codeclimate.com/github/dresselm/mscan.png)](https://codeclimate.com/github/dresselm/mscan)
=====

Mscan is a simple, command-line utility that can help you organize and clean up your media collection.  

For example, you can:

* determine if duplicate media exists on your backup drive(s) and how much space would be saved by deleting the duplicates
* determine if unique media exists on a drive that is not backed up
* determine what percentage of your media collection are photos and what percentage of those are jpegs

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

## Configuration

Configure the source and target (backup) directories.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
