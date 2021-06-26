require 'dupless/file/file'

module Dupless
  class DuplicateFiles
    attr_reader :files
    
    def initialize(files = nil)
      @files = Array.new
      @files.concat files
    end

    def << file
      @files << file
    end

    def inspect
      to_s
    end

    def to_s
      "files: #{@files}"
    end

    def == other
      @files == other.files
    end

    def write formatter: nil
      formatter.write entry: self
    end
  end
end
