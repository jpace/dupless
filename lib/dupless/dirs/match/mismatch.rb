require 'dupless/dirs/match/base'

module Dupless::Match
  class Mismatch < Base
    attr_reader :common
    attr_reader :x_only
    attr_reader :y_only
    
    def initialize x, y, x_only, common, y_only
      super(x, y)
      @x_only = x_only
      @common = common
      @y_only = y_only
    end

    def write formatter: nil
      formatter.write_mismatch match: self
    end

    def == other
      cmp = super
      if cmp == 0
        cmp = compare self, other, :common, :x_only, :y_only
      end
      cmp
    end
  end
end
