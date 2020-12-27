require 'dupless/dir/match/identical'
require 'dupless/dir/directory'
require 'dupless/dir/match/tc'

module Dupless::Match
  class IdenticalTest < TestCase
    objects = [
      # the x-only, etc., are not accurate to the definitions in tc.rb:
      Identical.new(D1, D3, Array[F1, F2]),
      Identical.new(D2, D4, Array[F2, F1]),
    ]
    
    param_test [
      objects[0],
      objects[1]
    ] do |m|
      result = m.type
      assert_equal :identical, result
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
      [ Array[F1, F2], objects[0] ],
      [ Array[F2, F1], objects[1] ]
    ] do |expx, m|
      result = m.common
      assert_equal expx, result
    end
  end
end
