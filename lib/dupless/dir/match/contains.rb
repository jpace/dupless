require 'dupless/dir/match/base'

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
  end
end
