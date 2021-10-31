require 'dupless/dirs/match/matcher'
require 'dupless/dir/directory'
require 'dupless/tc'

module Dupless
  module Dirs
    class MatcherTest < TestCase
      def self.build_params
        a = mockfile 1, "x", 7
        b = mockfile 2, "x", 7
        c = mockfile 1, "y", 7
        # d = mockfile 1, "x", 8

        d1 = Directory.new "a-b", [ a, b ]
        d2 = Directory.new "a-b", [ a, b ]
        d3 = Directory.new "b-a", [ b, a ]
        d4 = Directory.new "a-c", [ a, c ]
        d5 = Directory.new "a-b-c", [ a, b, c ]
        d6 = Directory.new "empty-1", [ ]
        d7 = Directory.new "empty-2", [ ]
        
        [
          [ Match::Identical,  d1, d2 ], 
          [ Match::Identical,  d1, d3 ], 
          [ Match::Mismatch,   d1, d4 ], 
          [ Match::XContainsY, d1, d5 ], 
          [ Match::XContainsY, d5, d1 ], 
          [ nil,               d1, d6 ], 
          [ nil,               d6, d7 ], 
        ]
      end

      param_test build_params.each do |exp, x, y|
        obj = Matcher.new
        puts "obj: #{obj}"
        
        result = obj.match x, y
        if exp
          assert_equal exp, result.class
        else
          assert_nil result
        end
      end

      def self.build_match_params
        a = mockfile 1, "x", 7
        b = mockfile 2, "x", 7
        c = mockfile 1, "y", 7
        # d = mockfile 1, "x", 8

        d1 = Directory.new "a-b", [ a, b ]
        d2 = Directory.new "a-b", [ a, b ]
        d3 = Directory.new "b-a", [ b, a ]
        d4 = Directory.new "a-c", [ a, c ]
        d5 = Directory.new "a-b-c", [ a, b, c ]
        d6 = Directory.new "empty-1", [ ]
        d7 = Directory.new "empty-2", [ ]
        
        [
          [ Match::Identical,  nil,        d1, d2 ], 
          [ nil,               :identical, d1, d2 ], 
          [ Match::Mismatch,   nil,        d1, d4 ], 
          [ nil,               :mismatch,  d1, d4 ], 
          [ Match::XContainsY, nil,        d1, d5 ], 
          [ nil,               :contains,  d1, d5 ], 
        ]
      end

      param_test build_match_params.each do |exp, type, x, y|
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
    end
  end
end
