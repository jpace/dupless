# -*- ruby -*-

require 'dupless/match/base'

module Dupless::Match
  class Identical < Base
    attr_reader :common
    
    def initialize x, y, common
      super(x, y)
      @common = common
    end

    def type
      :identical
    end

    def write
      puts "identical"
      puts "x: #{x}"
      puts "y: #{y}"
    end
  end
end
