require 'dupless/dirs/match/identical'
require 'dupless/dirs/match/tc'

module Dupless::Match
  class IdenticalTest < TestCase
    def self.build_params
      include Dirs
      include Files
      Array.new.tap do |a|
        a << [ X17_X27_1, X17_X27_1, [ X17, X27 ], [ X17_X27_1, X17_X27_1, [ X17, X27 ] ] ]
      end
    end

    param_test build_params.each do |expx, expy, expcommon, args|
      match = Identical.new(*args)
      result = match.x
      assert_equal expx, result
    end

    param_test build_params.each do |expx, expy, expcommon, args|
      match = Identical.new(*args)
      result = match.y
      assert_equal expy, result
    end

    param_test build_params.each do |expx, expy, expcommon, args|
      match = Identical.new(*args)
      result = match.common
      assert_equal expcommon, result
    end
  end
end
