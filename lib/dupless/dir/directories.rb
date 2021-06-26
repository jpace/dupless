require 'dupless/file/file'
require 'dupless/dir/directory'
require 'dupless/dirs/dirsmatcher'
require 'logue/loggable'

module Dupless
  class Directories
    include Logue::Loggable

    def initialize dirs
      raise "dirs cannot be null" unless dirs
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
    
    def duplicates filter: Hash.new, formatter: nil
      puts "directories ... filter: #{filter}"
      puts "directories ... filter: #{filter.class}"
      matcher = Dupless::Dirs::Matcher.new filter
      @dirs.sort.each do |xname, others|
        xdir = directory xname
        next unless xdir
        
        others.each do |yname|
          ydir = directory yname
          next unless ydir
          
          match = matcher.match xdir, ydir
          if match
            match.write formatter: formatter
          end
        end
      end
    end
  end
end
