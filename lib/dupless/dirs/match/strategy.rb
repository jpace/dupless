require 'dupless/dirs/match/fields'
require 'dupless/util/obj'
require 'logue/loggable'

module Dupless
  module Dirs
    class MatchStrategy
      include Logue::Loggable
      
      def match x, y
        xkids = x.children
        ykids = y.children
        fields = MatchFields.new
        @others = ykids.dup
        xkids.each do |child|
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
        xkids = x.children
        ykids = y.children
        return nil if xkids.size != ykids.size
        fields = MatchFields.new
        @others = ykids.dup
        xkids.each do |child|
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
  end
end

