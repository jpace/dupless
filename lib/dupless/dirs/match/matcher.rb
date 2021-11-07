require 'dupless/dirs/match/identical'
require 'dupless/dirs/match/contains'
require 'dupless/dirs/match/mismatch'
require 'dupless/dirs/match/strategy'
require 'dupless/util/obj'
require 'logue/loggable'

module Dupless
  module Dirs
    class Matcher
      include Logue::Loggable
      include Obj

      attr_reader :identical
      attr_reader :contains
      attr_reader :mismatch
      attr_reader :strategy

      def initialize options = Hash.new
        @identical = options.fetch :identical, true
        @contains = options.fetch :contains, true
        @mismatch = options.fetch :mismatch, true
        @strategy = options.fetch :strategy, MatchStrategy::Complete.new
      end

      def match x, y
        if m = @strategy.match(x, y)
          common = m.common
          xonly = m.x_only
          yonly = m.y_only
          
          if common.empty?
            nil
          elsif xonly.empty?
            if yonly.empty?
              @identical && Match::Identical.new(x, y, m.common)
            else
              # swapping x and y here, since y contains x
              @contains && Match::XContainsY.new(y, x, yonly, common)
            end
          elsif m.y_only.empty?
            @contains && Match::XContainsY.new(x, y, xonly, common)
          else                    
            @mismatch && Match::Mismatch.new(x, y, xonly, common, yonly)
          end
        end
      end

      def to_s
        to_string self, :identical, :contains, :mismatch, :strategy
      end
    end
  end
end
