require 'test_helper'
require 'dupless/mockfile'
require 'paramesan'

module Dupless
  class FileTest < Minitest::Test
    include Paramesan

    def self.build_params
      a = MockFile.new "", 1, "x", 7
      b = MockFile.new "", 2, "x", 7
      c = MockFile.new "", 1, "y", 7
      d = MockFile.new "", 1, "x", 8
      
      [
        [  0, a, a ],
        [ -1, a, b ],
        [  1, b, a ],
        [ -1, a, c ],
        [  1, c, a ],
        [ -1, a, d ],
        [  1, d, a ],
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
