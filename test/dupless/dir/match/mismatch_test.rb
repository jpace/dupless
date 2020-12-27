require 'dupless/dir/match/mismatch'
require 'dupless/dir/match/tc'

module Dupless::Match
  class MismatchTest < TestCase
    objects = [
      # the x-only, etc., are not accurate to the definitions in tc.rb:
      Mismatch.new(D1, D3, Array[F1], Array[F2], Array[F3]),
      Mismatch.new(D2, D4, Array[F3], Array[F4], Array[F5]),
    ]
    
    param_test [
      objects[0],
      objects[1]
    ] do |m|
      result = m.type
      assert_equal :mismatch, result
    end
    
    param_test [
      [ D1, objects[0] ],
      [ D2, objects[1] ]
    ] do |exp, m|
      result = m.x
      assert_equal exp, result
    end

    param_test [
      [ D3, objects[0] ],
      [ D4, objects[1] ]
    ] do |exp, m|
      result = m.y
      assert_equal exp, result
    end

    param_test [
      [ Array[F1], objects[0] ],
      [ Array[F3], objects[1] ],
    ] do |exp, m|
      result = m.x_only
      assert_equal exp, result
    end

    param_test [
      [ Array[F2], objects[0] ],
      [ Array[F4], objects[1] ],
    ] do |exp, m|
      result = m.common
      assert_equal exp, result
    end

    param_test [
      [ Array[F3], objects[0] ],
      [ Array[F5], objects[1] ],
    ] do |exp, m|
      result = m.y_only
      assert_equal exp, result
    end
  end
end
