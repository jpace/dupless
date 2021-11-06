require 'dupless/dirs/match/fields'

module Dupless
  module Dirs
    class MatchStrategyBase
      def match_child others, child
        others.each_with_index do |obj, idx|
          next unless obj
          if child == obj
            others[idx] = nil
            return [ child, obj ]
          end
        end
        nil
      end

      def to_s
        self.class.to_s
      end
    end

    class MatchStrategyComplete < MatchStrategyBase
      def match x, y
        xkids = x.children
        ykids = y.children
        fields = MatchFields.new
        others = ykids.dup
        xkids.each do |child|
          if m = match_child(others, child)
            fields.common << m
          else
            fields.x_only << child
          end
        end
        return nil unless fields.common.any?
        fields.y_only = others.compact
        fields
      end
    end

    class MatchStrategyIdenticalOnly < MatchStrategyBase
      def match x, y
        xkids = x.children
        ykids = y.children
        return nil if xkids.size != ykids.size
        fields = MatchFields.new
        others = ykids.dup
        xkids.each do |child|
          if m = match_child(others, child)
            fields.common << m
          else
            return nil
          end
        end
        fields.common.any? && others.compact.empty? ? fields : nil
      end
    end
  end
end
