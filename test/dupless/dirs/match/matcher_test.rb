require 'dupless/dirs/match/matcher'
require 'dupless/dir/directory'
require 'dupless/tc'

module Dupless
  module Dirs
    class MatcherTest < TestCase
      def self.build_match_type_params
        [
          [ Match::Identical,  nil,        D1, D2 ], 
          [ nil,               :identical, D1, D2 ], 
          [ Match::Mismatch,   nil,        D1, D8 ],
          [ nil,               :mismatch,  D1, D8 ], 
          [ Match::XContainsY, nil,        D5, D1 ], 
          [ nil,               :contains,  D5, D1 ], 
          [ Match::XContainsY, nil,        D1, D5 ], 
          [ nil,               :contains,  D1, D5 ], 
        ]
      end

      param_test build_match_type_params.each do |exp, type, x, y|
        args = Hash.new
        if type
          args[type] = false
        end
        obj = Matcher.new args
        result = obj.match x, y
        if exp
          assert_equal exp, result.class, "type: #{type}"
        else
          refute result
        end
      end
      
      def self.build_match_params
        [
          [ Match::XContainsY.new(D5, D1, [F3], [[F1, F1], [F2, F2]]), D5, D1 ], 
          [ Match::XContainsY.new(D5, D1, [F3], [[F1, F1], [F2, F2]]), D1, D5 ], 
        ]
      end

      param_test build_match_params.each do |exp, x, y|
        obj = Matcher.new Hash.new
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
