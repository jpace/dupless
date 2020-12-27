require 'dupless/dir/match/identical'
require 'dupless/dir/match/contains'
require 'dupless/dir/match/mismatch'
require 'logue/loggable'

module Dupless
  class Matcher
    include Logue::Loggable

    def create x, y
      x_only = Array.new
      common = Array.new
      y_only = Array.new

      others = y.children.dup
      x.children.each do |child|
        m = nil
        others.each_with_index do |obj, idx|
          next unless obj
          if child.match? obj
            others[idx] = nil
            m = [ child, obj ]
            common << m
            break
          end
        end

        unless m
          x_only << child
        end
      end

      y_only = others.compact
      
      debug "x_only  : #{x_only}"
      debug "common  : #{common}"
      debug "y_only  : #{y_only}"

      if common.empty?
        nil
      else
        instance x, y, x_only, common, y_only
      end
    end

    def instance x, y, x_only, common, y_only
      cls, args = if x_only.empty?
                    if y_only.empty?
                      [ Match::Identical, [ common ] ]
                    else
                      [ Match::YContainsX, [ y_only, common ] ]
                    end
                  elsif y_only.empty?
                    [ Match::XContainsY, [ x_only, common ] ]
                  else                    
                    [ Match::Mismatch, [ x_only, common, y_only ] ]
                  end
      
      cls.new x, y, *args
    end
  end
end
