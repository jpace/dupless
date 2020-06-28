# -*- ruby -*-

require 'dupless/file'
require 'dupless/entry'
require 'logue'

module Dupless
  class Set
    include Logue::Loggable

    attr_reader :files
    
    def initialize(enum = nil)
      @files = Array.new
      @files.concat enum
    end

    def << obj
      @files << obj
    end

    def duplicates
      # almost completely unoptimized:
      
      dups = Array.new
      nfiles = @files.size
      (0 ... nfiles).each do |i|
        x = @files[i]
        next if x.nil?
        dup = nil
        (0 ... nfiles).each do |j|
          next if i == j
          y = @files[j]
          next if y.nil?
          if x.match? y
            dup ||= Entry.new([x])
            dup << y
            @files[j] = nil
          end
        end
        if dup
          dups << dup
        end
      end
      
      dups
    end

    def inspect
      to_s
    end

    def to_s
      "files.size: #{@files.size}"
    end
  end
end
