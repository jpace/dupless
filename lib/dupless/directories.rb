# -*- ruby -*-

require 'dupless/file'
require 'dupless/entry'
require 'dupless/directory'
require 'dupless/match/identical'
require 'dupless/match/mismatch'
require 'dupless/matcher'
require 'logue'
require 'pp'

module Dupless
  class Directories
    include Logue::Loggable

    def initialize dirs
      @dirs = dirs
    end

    def dir_files dir
      dir.children.select(&:file?).collect { |child| Dupless::File.new child }
    end
    
    def duplicates
      dups = Array.new
      debug ">> dirs.size: #{@dirs.size}"
      # debug "@dirs: #{@dirs}"

      dirnames = @dirs.keys.sort
      
      dirnames[0 .. -2].each_with_index do |dir, idx|
        debug ">> dir: #{dir.class}"

        xfiles = dir_files dir
        debug "xfiles: #{xfiles}"

        x = Directory.new dir, xfiles
        debug "x: #{x}"
        
        # next if true
        
        dirnames[idx + 1 .. -1].each do |other|
          debug "OTHER: #{other.class}"
          
          yfiles = dir_files other
          debug "yfiles: #{yfiles}"

          y = Directory.new other, yfiles
          debug "y: #{y}"

          matcher = Matcher.new
          match = matcher.create x, y
          debug "match: #{match}"

          if match
            match.write
            puts
          end
        end
      end
    end
  end
end
