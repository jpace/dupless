require 'dupless/file/file'
require 'dupless/dir/directory'
require 'dupless/dir/match/identical'
require 'dupless/dir/match/mismatch'
require 'dupless/dir/matcher'
require 'logue/loggable'

module Dupless
  class Directories
    include Logue::Loggable

    def initialize dirs
      @dirs = dirs
    end

    def dir_files dir
      dir.children.select(&:file?).collect { |child| Dupless::File.new child }
    end

    # optimize for identical (same # of files)
    # for x includes y (x.size > y.size)
    # for y includes x (y.size > x.size)
    
    def duplicates filter: Array.new, formatter: nil
      if false
        duplicates_orig filter: filter
        return true
      end
      
      dups = Array.new
      isidentical = false
      
      matcher = Matcher.new
      dirnames = @dirs.keys.sort

      dirs = @dirs.keys.sort.collect do |name|
        files = dir_files name
        Directory.new name, files
      end

      dirs[0 .. -2].each_with_index do |xdir, idx|
        nxfiles = xdir.children.size
        dirs[idx + 1 .. -1].each do |ydir|
          nyfiles = ydir.children.size

          if isidentical && nxfiles != nyfiles
            next
          end

          match = matcher.create xdir, ydir

          if match && (filter.nil? || filter.empty? || filter.include?(match.class))
            match.write formatter: formatter
            puts
          end
        end
      end
    end

    # optimize for identical (same # of files)
    # for x includes y (x.size > y.size)
    # for y includes x (y.size > x.size)
    
    def duplicates_orig filter: Array.new, formatter: nil
      dups = Array.new

      isidentical = false
      
      matcher = Matcher.new
      dirnames = @dirs.keys.sort

      dirnames[0 .. -2].each_with_index do |xname, idx|
        xfiles = dir_files xname
        xdir = Directory.new xname, xfiles

        nxfiles = xfiles.size
        
        dirnames[idx + 1 .. -1].each do |yname|
          yfiles = dir_files yname

          nyfiles = yfiles.size

          if isidentical && nxfiles != nyfiles
            next
          end

          ydir = Directory.new yname, yfiles

          match = matcher.create xdir, ydir

          if match && (filter.nil? || filter.empty? || filter.include?(match.class))
            match.write formatter: formatter
            puts
          end
        end
      end
    end    
  end
end
