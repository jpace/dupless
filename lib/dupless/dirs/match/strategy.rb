require 'dupless/dirs/match/fields'

module Dupless
  module Dirs
    module MatchStrategy
    end
  end
end

module Dupless::Dirs::MatchStrategy
  class Base
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

    def match_fields
      Dupless::Dirs::MatchFields.new
    end

    def to_s
      self.class.to_s
    end
  end

  class Complete < Base
    def match x, y
      xkids = x.children
      ykids = y.children
      fields = match_fields
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

  class IdenticalOnly < Base
    def match x, y
      xkids = x.children
      ykids = y.children
      return nil if xkids.size != ykids.size
      fields = match_fields
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
