# -*- ruby -*-

require 'logue'

module Dupless
  class Match
    include Logue::Loggable

    attr_reader :x
    attr_reader :y
    attr_reader :type
    attr_reader :matched
    attr_reader :unmatched
    
    def initialize x, y, type
      @x = x
      @y = y
      @type = type
      @matched = nil
      @unmatched = nil
    end

    def to_s
      "type: #{@type}"
    end

    def inspect
      to_s
    end
  end
end
