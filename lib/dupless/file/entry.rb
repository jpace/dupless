require 'dupless/file/file'

module Dupless
  class Entry
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

    def print format: :long
      case format
      when :long
        @files.each do |file|
          puts "file: #{file}"
        end
      when :short
        @files.each do |file|
          puts file
        end
      end
    end
  end
end
