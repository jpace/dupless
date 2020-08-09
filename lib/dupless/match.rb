# -*- ruby -*-

require 'pathname'
require 'logue'

module Dupless
  class Match
    include Logue::Loggable

    attr_reader :x
    attr_reader :y
    attr_reader :type
    attr_reader :matched
    attr_reader :unmatched
    
    def initialize x, y
      @x = x
      @y = y
      @type = nil

      run
    end

    def run
      @matched = Array.new
      @unmatched = Array.new

      others = y.children.dup
      x.children.each do |child|
        m = nil
        others.each_with_index do |obj, idx|
          next unless obj
          if child.match? obj
            others[idx] = nil
            m = [ child, obj ]
            break
          end
        end

        info "m: #{m}"

        if m
          @matched << m
        else
          @unmatched << child
        end
      end

      info "matched: #{@matched}"
      info "unmatched: #{@unmatched}"
      info "others: #{others}"

      @type = if @matched.size == x.children.size && others.compact.empty?
                :identical
              else
                :mismatch
              end
    end

    def to_s
      "type: #{@type}"
    end

    def inspect
      to_s
    end
  end
end
