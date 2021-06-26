require 'dupless/file/dupfiles'

module Dupless
  class FileMatcher
    include Logue::Loggable

    attr_reader :duplicates
    
    def initialize
      @duplicates = Array.new
    end

    def add_duplicate dup, x, y
      unless dup
        dup = Dupless::DuplicateFiles.new([x])
        @duplicates << dup
      end
      dup << y
      dup
    end
  end
end
