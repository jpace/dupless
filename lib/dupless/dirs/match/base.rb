require 'logue/loggable'
require 'dupless/util/obj'

module Dupless
  module Match
  end
end

module Dupless::Match
  class Base
    include Logue::Loggable
    include Dupless::Obj

    attr_reader :x
    attr_reader :y
    
    def initialize x, y
      @x = x
      @y = y
    end

    def inspect
      to_s
    end

    def to_s
      to_string self, :x, :y
    end

    def == other
      compare self, other, :x, :y
    end
  end
end
