require 'dupless/dirs/match/fields'

module Dupless
  module Dirs
    module MatchStrategy
    end
  end
end

module Dupless::Dirs::MatchStrategy
  class Base
    def match x, y
      xkids = x.children
      ykids = y.children
      if pre_filtered? xkids, ykids
        nil
      else
        @fields = Dupless::Dirs::MatchFields.new
        @fields.y_only = ykids.dup
        if match_elements(xkids) && @fields.common.any?
          @fields.y_only.compact!
          post_filtered? ? nil : @fields
        end
      end
    end

    def match_child child
      @fields.y_only.each_with_index do |obj, idx|
        next unless obj
        if child == obj
          @fields.y_only[idx] = nil
          @fields.common << [ child, obj ]
          return true
        end
      end
      false
    end

    def pre_filtered? xkids, ykids
      false
    end

    def post_filtered?
      false
    end
  end

  class Complete < Base
    def match_elements xkids
      xkids.each do |child|
        unless match_child child
          @fields.x_only << child
        end
      end
    end
  end

  class IdenticalOnly < Base
    def pre_filtered? xkids, ykids
      xkids.size != ykids.size
    end
    
    def match_elements xkids
      xkids.each do |child|
        unless match_child child
          return nil
        end
      end
    end

    def post_filtered?
      @fields.y_only.any?
    end
  end
end
