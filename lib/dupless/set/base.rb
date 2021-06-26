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
end
