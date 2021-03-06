require 'dupless/app/compare'
require 'dupless/dir/dirmatcher'
require 'dupless/dir/directories'

module Dupless
  class DirCompare < Compare
    def initialize(*args, type: :singlepass, cachename: nil)
      super(*args, type: type, cachename: cachename, matcher: Dupless::DirMatcher.new)
    end

    def show_duplicates filter: Hash.new, formatter: nil
      puts "dircompare ... filter: #{filter}"
      dirs = @set.matcher.matchdirs
      matcher = Dupless::Directories.new dirs
      matcher.duplicates filter: filter, formatter: formatter
    end
  end
end
