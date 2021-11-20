require 'dupless/dirs/match/base'

module Dupless::Match
  class Identical < Base
    attr_reader :common
    
    def initialize x, y, common
      super(x, y)
      @common = common
    end

    def write formatter: nil
      formatter ||= Dupless::Match::BriefFormatter.new
      formatter.write_identical match: self
    end

    def to_s
      to_string self, :common
    end
    
    def == other
      cmp = super
      if cmp == 0
        cmp = compare self, other, :common
      end
      cmp == 0
    end
  end
end
