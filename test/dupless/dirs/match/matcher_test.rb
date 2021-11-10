require 'dupless/dirs/match/matcher'
require 'dupless/dir/directory'
require 'dupless/tc'

module Dupless
  module Dirs
    class MatcherTest < Dupless::TestCase
      PARAMS = Hash.new.tap do |h|
        h[:identical] = Array.new.tap do |a|
          a << [ Match::Identical.new(D1, D3, [[F1, F1], [F2, F2]]), D1, D3 ]
        end
        h[:contains] = Array.new.tap do |a|
          [ [ D5, D1 ], [ D1, D5 ] ].each do |xy|
            a << [ Match::XContainsY.new(D5, D1, [F3], [[F1, F1], [F2, F2]]), *xy ]
          end
        end
        h[:mismatch] = Array.new.tap do |a|
          a << [ Match::Mismatch.new(D1, D4, [F2], [[F1, F1]], [F3]), D1, D4 ]
        end
      end
      
      def self.build_match_default_params
        Array.new.tap do |a|
          PARAMS.each do |type, matches|
            a.concat matches
          end
        end
      end

      param_test build_match_default_params.each do |exp, x, y|
        obj = Matcher.new Hash.new
        result = obj.match x, y
        if exp
          assert_equal exp, result
        else
          refute result
        end
      end

      def self.build_match_identical_params
        Array.new.tap do |a|
          PARAMS.each do |type, matches|
            if type == :identical
              a.concat matches
            else
              a.concat(matches.collect { |fields| [nil, *(fields[1 .. -1])] })
            end
          end
        end
      end
      
      param_test build_match_identical_params.each do |exp, x, y|
        obj = Matcher.new strategy: MatchStrategy::IdenticalOnly.new
        result = obj.match x, y
        if exp
          assert_equal exp, result
        else
          refute result
        end
      end
    end
  end
end
