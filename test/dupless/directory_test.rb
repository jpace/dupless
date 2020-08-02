require 'dupless/directory'
require 'dupless/mockfile'
require 'dupless/tc'

module Dupless
  class DirectoryTest < TestCase
    def self.mockfile size, bytes, checksum
      fname = [ size, bytes, checksum ].join "-"
      MockFile.new fname, size, bytes, checksum
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
      
      [
        [ :identical, d1, d2 ],
        [ :identical, d1, d3 ],
        [ :mismatch,  d1, d4 ]
      ]
    end

    param_test build_params.each do |exp, x, y|
      result = x.match y
      assert_equal exp, result
    end
  end
end
