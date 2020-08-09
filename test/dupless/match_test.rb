require 'dupless/match'
require 'dupless/directory'
require 'dupless/mockfile'
require 'dupless/tc'

module Dupless
  class MatchTest < TestCase
    def self.mockfile size, bytes, checksum
      MockFile.create size, bytes, checksum
    end
    
    def self.build_params
      a = mockfile 1, "x", 7
      b = mockfile 2, "x", 7
      c = mockfile 1, "y", 7
      d = mockfile 1, "x", 8

      d1 = Directory.new "a-b", [ a, b ]
      d2 = Directory.new "a-b", [ a, b ]
      d3 = Directory.new "b-a", [ b, a ]
      d4 = Directory.new "a-c", [ a, c ]
      d5 = Directory.new "a-b-c", [ a, b, c ]
      d6 = Directory.new "empty-1", [ ]
      d7 = Directory.new "empty-2", [ ]
      
      [
        [ :identical, d1, d2 ],
        [ :mismatch,  d1, d4 ],
     ]
    end

    param_test build_params.each do |type, x, y|
      m = Match.new x, y, type
      result = m.type
      assert_equal type, result
    end

    param_test build_params.each do |type, x, y|
      m = Match.new x, y, type
      result = m.x
      assert_equal x, result
    end

    param_test build_params.each do |type, x, y|
      m = Match.new x, y, type
      result = m.y
      assert_equal y, result
    end
  end
end