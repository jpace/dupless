require 'dupless/dirs/match/matcher'
require 'dupless/dir/directory'
require 'dupless/tc'

module Dupless
  module Dirs
    class MatchStrategyTest < TestCase
      def self.match_fields common: Array.new, x_only: Array.new, y_only: Array.new
        MatchFields.new common: common, x_only: x_only, y_only: y_only
      end

      def self.directory name, *children
        Directory.new name, children
      end

      module Files
        def self.mockfile(*args)
          Dupless::TestCase.mockfile *args
        end
        
        A = mockfile 1, "x", 7
        B = mockfile 2, "x", 7
        C = mockfile 1, "y", 7
        D = mockfile 1, "x", 8
      end

      module Dirs
        def self.directory name, *children
          Directory.new name, children
        end
        
        AB1 = directory "a-b", Files::A, Files::B
        AB2 = directory "a-b", Files::A, Files::B
        BA = directory "b-a", Files::B, Files::A
        AC = directory "a-c", Files::A, Files::C
        ABC = directory "a-b-c", Files::A, Files::B, Files::C
        EMPTY1 = directory "empty-1"
        EMPTY2 = directory "empty-2"
        D = directory "d", Files::D
      end

      def self.build_params
        params = Array.new

        # identical
        exp = match_fields common: [ [ Files::A, Files::A ], [ Files::B, Files::B ] ]
        params << [ exp, exp, Dirs::AB1, Dirs::AB2 ]
        params << [ exp, exp, Dirs::AB1, Dirs::BA ]

        # overlap/mismatch
        exp = match_fields common: [ [ Files::A, Files::A ] ], x_only: [ Files::B ], y_only: [ Files::C ]
        params << [ exp, nil, Dirs::AB1, Dirs::AC ]

        exp = match_fields common: [ [ Files::A, Files::A ], [ Files::B, Files::B ] ], x_only: [ Files::C ]
        params << [ exp, nil, Dirs::ABC, Dirs::AB1 ]
        
        # nothing common
        params << [ nil, nil, Dirs::AB1, Dirs::D ]
        
        # both empty
        params << [ nil, nil, Dirs::EMPTY1, Dirs::EMPTY2 ]
      end

      param_test build_params.each do |exp_complete, exp_identical, x, y|
        obj = MatchStrategyComplete.new
        result = obj.match x, y
        if exp_complete
          assert_equal exp_complete, result
        else
          assert_nil result
        end
      end
      
      param_test build_params.each do |exp_complete, exp_identical, x, y|
        obj = MatchStrategyIdenticalOnly.new
        result = obj.match x, y
        if exp_identical
          assert_equal exp_identical, result
        else
          assert_nil result
        end
      end
    end
  end
end
