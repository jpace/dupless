require 'dupless/file/file'
require 'dupless/dir/directory'
require 'dupless/dir/matcher'
require 'logue/loggable'

module Dupless
  class Matcher2
    include Logue::Loggable

    def initialize dirs
      @dirs = dirs
    end

    def dir_files dir
      dir.children.collect do |kid|
        if kid.file?
          Dupless::File.new kid
        else
          return nil
        end
      end
    end

    def directory dirname
      files = dir_files dirname
      files && Directory.new(dirname, files)
    end

    # optimize:
    # for identical (same # of files)
    # for contains (x.size > y.size)
    
    def duplicates filter: Array.new, formatter: nil
      matcher = Matcher.new
      @dirs.sort.each do |xname, others|
        xdir = directory xname
        next unless xdir
        
        others.each do |yname|
          ydir = directory yname
          next unless ydir
          
          match = matcher.create xdir, ydir
          if match && (filter.nil? || filter.empty? || filter.include?(match.class))
            match.write formatter: formatter
          end
        end
      end
    end
  end
end
