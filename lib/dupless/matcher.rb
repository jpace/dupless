# -*- ruby -*-

require 'logue'
require 'dupless/match'

module Dupless
  class Matcher
    include Logue::Loggable

    def create x, y
      matched = Array.new
      unmatched = Array.new

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
          matched << m
        else
          unmatched << child
        end
      end

      info "matched: #{matched}"
      info "unmatched: #{unmatched}"
      info "others: #{others}"

      type = if matched.size == x.children.size && others.compact.empty?
                :identical
              else
                :mismatch
             end

      Match.new x, y, type
    end
  end
end
