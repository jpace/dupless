# -*- ruby -*-

require 'dupless/file'
require 'dupless/entry'
require 'logue'

module Dupless::Set
  class Base
    include Logue::Loggable

    def initialize
      @duplicates = nil
    end

    def duplicates
      @duplicates ||= run
    end
    
    def run
      @duplicates = Array.new
      
      start = Time.now
      info "start: #{start}"
      
      dups = execute

      done = Time.now
      info "done: #{done}"

      diff = done - start
      info "diff: #{diff}"

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
      dup << y
      dup
    end
  end
end
