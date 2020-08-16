require 'dupless/match/identical'
require 'dupless/match/tc'
require 'dupless/directory'
require 'dupless/mockfile'

module Dupless::Match
  class IdenticalTest < TestCase
    def self.build_params
      [
        [ D1, Identical.new(D1, D2, Array.new) ],
        [ D2, Identical.new(D2, D1, Array.new) ],
      ]
    end

    param_test build_params do |expx, m|
      result = m.x
      assert_equal expx, result
    end

    param_test build_params do |expx, m|
      result = m.type
      assert_equal :identical, result
    end
  end
end
