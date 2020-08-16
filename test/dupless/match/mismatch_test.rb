require 'dupless/match/mismatch'
require 'dupless/match/tc'

module Dupless::Match
  class MismatchTest < TestCase
    def self.build_params
      [
        [ D1, Mismatch.new(D1, D3, Array.new, Array.new, Array.new) ],
        [ D2, Mismatch.new(D2, D3, Array.new, Array.new, Array.new) ],
      ]
    end

    param_test build_params do |expx, m|
      result = m.x
      assert_equal expx, result
    end

    param_test build_params do |expx, m|
      result = m.type
      assert_equal :mismatch, result
    end
  end
end
