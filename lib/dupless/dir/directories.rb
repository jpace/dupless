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
    
    def duplicates filter: Array.new
      dups = Array.new
      debug ">> dirs.size: #{@dirs.size}"
      # debug "@dirs: #{@dirs}"

      isidentical = false
      
      matcher = Matcher.new
      dirnames = @dirs.keys.sort
      
      dirnames[0 .. -2].each_with_index do |dir, idx|
        debug ">> dir: #{dir.class}"

        xfiles = dir_files dir
        debug "xfiles: #{xfiles}"

        x = Directory.new dir, xfiles
        debug "x: #{x}"

        nxfiles = xfiles.size
        
        dirnames[idx + 1 .. -1].each do |other|
          debug "OTHER: #{other.class}"
          
          yfiles = dir_files other
          debug "yfiles: #{yfiles}"

          nyfiles = yfiles.size

          if isidentical && nxfiles != nyfiles
            next
          end

          y = Directory.new other, yfiles
          debug "y: #{y}"

          match = matcher.create x, y

          if match && (filter.nil? || filter.empty? || filter.include?(match.class))
            match.write format: :summary
            puts
          end
        end
      end
    end
  end
end
