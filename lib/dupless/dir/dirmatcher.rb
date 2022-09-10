require 'dupless/dirs/directories'
require 'dupless/util/timer'
require 'logue/loggable'
require 'set'

module Dupless
  class DirMatcher
    include Logue::Loggable

    attr_reader :matchdirs
    
    def initialize
      @dir_to_files = Hash.new { |h, k| h[k] = Array.new }
      @matchdirs = Hash.new { |h, k| h[k] = ::Set.new }
    end

    def directories
      @dir_to_files
    end
    
    def add_duplicate dup, x, y
      xd = x.pathname.parent
      yd = y.pathname.parent

      # info "x: #{x}"
      # info "y: #{y}"
      
      # info "xd: #{xd}"
      # info "yd: #{yd}"

      @dir_to_files[xd] << x
      @dir_to_files[yd] << y

      if xd != yd
        dirs = [ xd, yd ].sort
        @matchdirs[dirs.first] << dirs.last
      end
      dup
    end
  end
end
