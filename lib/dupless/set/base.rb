require 'dupless/file/file'
require 'dupless/dir/directories'
require 'dupless/file/entry'
require 'dupless/util/timer'
require 'logue/loggable'
require 'set'

module Dupless::Set
  class Base
    include Logue::Loggable
    
    attr_reader :matchdirs

    def initialize
      @entries = nil
      @dirs = nil
      @matchdirs = Hash.new { |h, k| h[k] = Set.new }
    end

    def duplicates
      entries
    end

    def entries
      unless @entries
        run
      end
      @entries
    end

    def directories
      unless @dirs
        run
      end
      @dirs
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
      yd = y.pathname.parent

      if xd != yd
        dirs = [ xd, yd ].sort
        @matchdirs[dirs.first] << dirs.last
      end
      
      @dirs[xd] << x
      @dirs[yd] << y
      
      dup << y
      dup
    end
  end
end
