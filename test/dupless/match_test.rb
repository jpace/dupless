require 'dupless/match'
require 'dupless/directory'
require 'dupless/mockfile'
require 'dupless/tc'

module Dupless::Match
  class MatchTest < Dupless::TestCase
    def self.directory name, *children
      Dupless::Directory.new name, children
    end
    
    def self.build_params
      a = mockfile 1, "x", 7
      b = mockfile 2, "x", 7
      c = mockfile 1, "y", 7
      # d = mockfile 1, "x", 8

      d1 = directory "a-b", [ a, b ]
      d2 = directory "a-b", [ a, b ]
      d3 = directory "b-a", [ b, a ]
      # d4 = directory "a-c", [ a, c ]
      # d5 = directory "a-b-c", [ a, b, c ]
      # d6 = directory "empty-1", [ ]
      # d7 = directory "empty-2", [ ]
      
      [
        [ d1, :identical, Identical.new(d1, d2, Array.new) ],
        [ d2, :identical, Identical.new(d2, d1, Array.new) ],
        [ d1, :mismatch,  Mismatch.new(d1, d3, Array.new, Array.new, Array.new) ],
        [ d2, :mismatch,  Mismatch.new(d2, d3, Array.new, Array.new, Array.new) ],
      ]
    end

    param_test build_params do |expx, exptype, m|
      result = m.x
      assert_equal expx, result
    end

    param_test build_params do |expx, exptype, m|
      result = m.type
      assert_equal exptype, result
    end
  end
end
