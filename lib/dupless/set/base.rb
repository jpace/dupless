require 'dupless/util/timer'
require 'logue/loggable'
require 'set'

module Dupless::Set
  class Base
    include Logue::Loggable

    attr_reader :matcher
    
    def initialize matcher: nil
      @matcher = matcher
    end

    def run
      Dupless::Timer.new.run { execute }
    end

    def execute
      raise "method not implemented"
    end

    def inspect
      to_s
    end

    def add_duplicate dup, x, y
      @matcher.add_duplicate dup, x, y
    end
  end

  class WithFiles < Base
    attr_reader :files
    
    def initialize files: nil, matcher: nil
      super matcher: matcher
      @files = files || Array.new
    end

    def << obj
      @files << obj
    end

    def to_s
      "files.size: #{@files.size}"
    end
  end  
end
