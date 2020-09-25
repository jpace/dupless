# -*- ruby -*-

require 'dupless/file'
require 'dupless/directories'
require 'dupless/entry'
require 'logue'
require 'pp'

module Dupless::Set
  class Base
    include Logue::Loggable

    def initialize
      @duplicates = nil
      @dirs = nil
    end

    def duplicates
      @duplicates ||= run
    end
    
    def duplicate_directories
      unless @dirs
        run
      end
      Dupless::Directories.new(@dirs).duplicates
    end
    
    def run
      @duplicates = Array.new
      @dirs = Hash.new { |h, k| h[k] = Array.new }
      
      start = Time.now
      # debug "start: #{start}"
      
      dups = execute

      done = Time.now
      # debug "done: #{done}"

      diff = done - start
      # debug "diff: #{diff}"

      @duplicates
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
        @duplicates << dup
      end

      # info "x.pathname: #{x.pathname}"

      xd = x.pathname.parent
      # info "xd: #{xd}"

      yd = y.pathname.parent
      # info "yd: #{yd}"
      
      @dirs[xd] << x
      @dirs[yd] << y
      
      # info "dirs.size: #{@dirs.size}"
      
      # info "dirs:"
      # pp @dirs
      
      dup << y
      dup
    end
  end
end
