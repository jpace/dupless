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
        puts "options: #{options}"
        @identical = options.fetch :identical, true
        @contains = options.fetch :contains, true
        @mismatch = options.fetch :mismatch, true
        @strategy = options.fetch :strategy, MatchStrategy.new
        puts "@strategy: #{@strategy}"
      end

      def match x, y
        m = @strategy.match x, y
        return nil unless m
        create_match x, y, m
      end

      def create_match x, y, m
        if m.common.empty?
          nil
        elsif m.x_only.empty?
          if m.y_only.empty?
            @identical && Match::Identical.new(x, y, m.common)
          else
            @contains && Match::XContainsY.new(y, x, m.y_only, m.common)
          end
        elsif m.y_only.empty?
          @contains && Match::XContainsY.new(x, y, m.x_only, m.common)
        else                    
          @mismatch && Match::Mismatch.new(x, y, m.x_only, m.common, m.y_only)
        end
      end

      def to_s
        to_string self, :identical, :contains, :mismatch, :strategy
      end
    end
  end
end
