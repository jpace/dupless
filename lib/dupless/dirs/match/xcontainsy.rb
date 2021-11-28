require 'dupless/dirs/match/base'

module Dupless::Match
  class XContainsY < Base
    attr_reader :common
    attr_reader :only
    
    def initialize x, y, only, common
      super(x, y)
      @only = only
      @common = common
    end

    def write formatter: nil
      formatter.write_contains match: self
    end

    def to_s
      to_string self, :common, :only
    end

    def == other
      cmp = super
      if cmp == 0
        cmp = compare self, other, :common, :only
      end
      cmp.zero?
    end
  end
end
