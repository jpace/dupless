require 'logue/loggable'

module Dupless
  module Match
  end
end

module Dupless::Match
  class Base
    include Logue::Loggable

    attr_reader :x
    attr_reader :y
    
    def initialize x, y
      @x = x
      @y = y
    end

    def inspect
      to_s
    end
  end
end
