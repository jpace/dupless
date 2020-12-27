require 'dupless/file/file'
require 'dupless/dir/directories'
require 'dupless/file/entry'
require 'dupless/util/timer'
require 'logue/loggable'

module Dupless::Set
  class Base
    include Logue::Loggable

    def initialize
      @entries = nil
      @dirs = nil
    end

    def duplicates
      @entries ||= run
    end

    def directories
      unless @dirs
        run
      end
      @dirs
    end
    
    def duplicate_directories
      unless @dirs
        run
      end
      Dupless::Directories.new(@dirs).duplicates
    end
    
    def run
      @entries = Array.new
      @dirs = Hash.new { |h, k| h[k] = Array.new }

      Dupless::Timer.new.run { execute }

      @entries
    end

    def execute
      raise "method not implemented"
    end

    def inspect
      to_s
    end

    def add_duplicate dup, x, y
      unless dup
        dup = Dupless::Entry.new([x])
        @entries << dup
      end

      xd = x.pathname.parent
      # debug "xd: #{xd}"

      yd = y.pathname.parent
      # debug "yd: #{yd}"
      
      @dirs[xd] << x
      @dirs[yd] << y
      
      dup << y
      dup
    end
  end
end
