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
        if fields = @strategy.match(x, y)
          create_match fields, x, y
        end
      end

      def create_match fields, x, y
        if fields.x_only.empty?
          if fields.y_only.empty?
            create_identical_match fields, x, y
          else
            # swapping x and y here, since y contains x
            create_contains_match fields, x, y, swap: true
          end
        elsif fields.y_only.empty?
          create_contains_match fields, x, y, swap: false
        else                    
          create_mismatch fields, x, y
        end
      end

      def create_identical_match fields, x, y
        @identical && Match::Identical.new(x, y, fields.common)
      end

      def create_contains_match fields, x, y, swap: false
        if @contains
          args = swap ? [ y, x, fields.y_only ] : [ x, y, fields.x_only ]
          args << fields.common
          Match::XContainsY.new(*args)
        end
      end

      def create_mismatch fields, x, y
        @mismatch && Match::Mismatch.new(x, y, fields.x_only, fields.common, fields.y_only)
      end

      def to_s
        to_string self, :identical, :contains, :mismatch, :strategy
      end
    end
  end
end
