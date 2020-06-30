# -*- ruby -*-

require 'dupless/file'
require 'dupless/entry'
require 'logue'

module Dupless
  class Set
    include Logue::Loggable

    attr_reader :files
    
    def initialize files: Array.new
      @files = files.nil? ? Array.new : files
    end

    def << obj
      @files << obj
    end

    def duplicates
    end

    def inspect
      to_s
    end

    def to_s
      "files.size: #{@files.size}"
    end
  end
end
