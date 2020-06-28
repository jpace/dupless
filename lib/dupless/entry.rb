# -*- ruby -*-

require 'dupless/file'

module Dupless
  class Entry
    attr_reader :files
    
    def initialize(enum = nil)
      @files = Array.new
      @files.concat enum
    end

    def << obj
      @files << obj
    end

    def inspect
      to_s
    end

    def to_s
      "files.size: #{@files.size}"
    end

    def == other
      @files == other.files
    end
  end
end
