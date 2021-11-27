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
        @others = ykids.dup
        @fields = Dupless::Dirs::MatchFields.new
        match_elements(xkids) ? @fields : nil
      end
    end

    def to_s
      self.class.to_s
    end

    def match_child child
      @others.each_with_index do |obj, idx|
        next unless obj
        if child == obj
          @others[idx] = nil
          @fields.common << [ child, obj ]
          return true
        end
      end
      false
    end

    def pre_filtered? xkids, ykids
      false
    end
  end

  class Complete < Base
    def match_elements xkids
      xkids.each do |child|
        unless m = match_child(child)
          @fields.x_only << child
        end
      end
      if @fields.common.any?
        @fields.y_only = @others.compact
      end
    end
  end

  class IdenticalOnly < Base
    def pre_filtered? xkids, ykids
      xkids.size != ykids.size
    end
    
    def match_elements xkids
      xkids.each do |child|
        unless m = match_child(child)
          return nil
        end
      end
      @fields.common.any? && @others.compact.empty?
    end
  end
end
