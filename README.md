# Dupless

Find duplicated and overlapping directories, files, and trees in a file system.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dupless'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dupless

## Usage

Two applications exist, with different implementations.

### dupless

This finds duplicated files and directories that at least partially match the files in another
directory.

File comparison is based on content of the file, not file names, thus like `diff`.

This uses caching to avoid repeated reading of files.

When a pair (or more) of files match from two directories, then the directories are compared, and
may be one of these types:

 * Identical: each file in both directories has a match in the other directory.
 
 * Contains: each file in one directory has a file in another directory, i.e., the first
 directory is a superset of the second.
 
 * Mismatch: two directories have files in common, i.e., an intersection of at least one
 element.
 
### duptree

This find duplicated hierarchies of files and directories, based on name only (not on
file content, in contrast to `dupless`).

Two directories are equal (identical) if all directories and files within each directory
has a match in the second one.

This does not use caching.

Supersets ("contains") and intersections ("mismatches") are not calculated.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are somewhat welcome on GitHub at https://github.com/jpace/dupless.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
