# -*- ruby -*-

require 'logue'

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

    def to_s
      "type: #{type}"
    end

    def inspect
      to_s
    end
  end

  class Identical < Base
    attr_reader :matched
    
    def initialize x, y, matched
      super(x, y)
      @matched = matched
    end

    def type
      :identical
    end
  end

  class Mismatch < Base
    attr_reader :matched
    attr_reader :unmatched
    
    def initialize x, y, matched, unmatched
      super(x, y)
      @matched = matched
      @unmatched = unmatched
    end

    def type
      :mismatch
    end
  end
end
