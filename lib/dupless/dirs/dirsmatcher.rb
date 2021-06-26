require 'dupless/dirs/match/identical'
require 'dupless/dirs/match/contains'
require 'dupless/dirs/match/mismatch'
require 'logue/loggable'

module Dupless
  module Dirs
    class MatchFields
      attr_reader :x_only
      attr_reader :common
      attr_reader :y_only
      
      def initialize
        @x_only = Array.new
        @common = Array.new
        @y_only = Array.new
      end
    end
    
    class MatchStrategy
      include Logue::Loggable
      
      def match x, y
        fields = MatchFields.new
        @others = y.children.dup
        x.children.each do |child|
          m = match_child child
          if m
            fields.common << m
          else
            fields.x_only << child
          end
        end
        fields.y_only.concat @others.compact
        fields.common.any? && fields
      end

      def match_child child
        @others.each_with_index do |obj, idx|
          next unless obj
          if child.match? obj
            @others[idx] = nil
            return [ child, obj ]
          end
        end
        nil
      end

      def to_s
        self.class.to_s
      end
    end

    class IdenticalMatchStrategy < MatchStrategy
      def match x, y
        fields = MatchFields.new
        @others = y.children.dup
        x.children.each do |child|
          m = match_child child
          if m
            fields.common << m
          else
            return nil
          end
        end
        @others.compact.empty? && fields
      end
    end
    
    class Matcher
      include Logue::Loggable

      attr_reader :identical
      attr_reader :contains
      attr_reader :mismatch
      attr_reader :strategy

      def initialize options = Hash.new
        @identical = options.fetch :identical, true
        @contains = options.fetch :contains, true
        @mismatch = options.fetch :mismatch, true
        @strategy = options.fetch :strategy, MatchStrategy.new
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
        [ :identical, :contains, :mismatch, :strategy ].collect do |field|
          "#{field}: #{send(field).to_s}"
        end.join ", "
      end
    end
  end
end
