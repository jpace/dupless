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
  end
end
