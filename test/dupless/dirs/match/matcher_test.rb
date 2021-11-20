require 'dupless/dirs/match/matcher'
require 'dupless/dir/directory'
require 'dupless/tc'

module Dupless
  module Dirs
    class MatcherTest < Dupless::TestCase
      # collision of Dupless::TestCase::Dirs and Dupless::Dirs
      D = Dupless::TestCase::Dirs
      F = Dupless::TestCase::Files
      
      PARAMS = Hash.new.tap do |h|
        h[:identical] = Array.new.tap do |a|
          a << [ Match::Identical.new(D::X17_X27_1, D::X17_X27_2, [[F::X17, F::X17], [F::X27, F::X27]]), D::X17_X27_1, D::X17_X27_2 ]
        end
        h[:contains] = Array.new.tap do |a|
          dirs = [ D::X17_X27_1, D::X17_1 ]
          [ dirs, dirs.reverse ].each do |xy|
            a << [ Match::XContainsY.new(D::X17_X27_1, D::X17_1, [F::X27], [[F::X17, F::X17]]), *xy ]
          end
        end
        h[:mismatch] = Array.new.tap do |a|
          a << [ Match::Mismatch.new(D::X17_X27_1, D::X17_Y17_1, [F::X27], [[F::X17, F::X17]], [F::Y17]), D::X17_X27_1, D::X17_Y17_1 ]
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
