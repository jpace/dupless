require 'dupless/file'
require 'dupless/tc'

module Dupless
  class FileTest < TestCase
    def self.build_params
      a = mockfile 1, "x", 7
      b = mockfile 2, "x", 7
      c = mockfile 1, "y", 7
      d = mockfile 1, "x", 8
      e = mockfile 1, "x", 7
      
      [
        [  0, a, a ],
        [ -1, a, b ],
        [  1, b, a ],
        [ -1, a, c ],
        [  1, c, a ],
        [ -1, a, d ],
        [  1, d, a ],
        [  0, a, e ],
      ]
    end

    param_test build_params.each do |exp, x, y|
      result = x <=> y
      assert_equal exp, result
    end

    param_test build_params.each do |exp, x, y|
      result = x == y
      assert_equal exp == 0, result
    end
  end
end
