# -*- ruby -*-

require 'pathname'
require 'logue'

module Dupless
  class Directory
    include Comparable
    include Logue::Loggable

    attr_reader :pathname
    
    def initialize what, children = nil
      @pathname = what.kind_of?(Pathname) ? what : Pathname.new(what)
      @children = children
    end

    def children
      @children ||= @pathname.children
    end

    def bytes num
      @pathname.read num
    end

    def match other
      matched = Array.new
      unmatched = Array.new
      others = other.children.dup
      children.each do |child|
        m = nil
        others.each_with_index do |obj, idx|
          if obj
            if child.match? obj
              others[idx] = nil
              m = [ child, obj ]
              break
            end
          end
        end

        info "m: #{m}"

        if m
          matched << m
        else
          unmatched << child
        end
        
      end

      info "matched: #{matched}"
      info "unmatched: #{unmatched}"

      if matched.size == children.size
        :identical
      else
        :mismatch
      end
    end

    def to_s
      @pathname.to_s + "; #children: " + @children.size.to_s
    end

    def inspect
      to_s
    end
  end
end
