require 'dupless/dirs/match/identical'
require 'dupless/dirs/match/tc'

module Dupless::Match
  class IdenticalTest < TestCase
    def run_test index, field
      args = [ Dirs::X17_X27_1, Dirs::X17_X27_1, Array[Files::X17, Files::X27] ]
      match = Identical.new(*args)
      expected = args[index]
      result = match.send field
      assert_equal expected, result
    end

    def test_x
      run_test 0, :x
    end

    def test_y
      run_test 1, :y
    end
    
    def test_common
      run_test 2, :common
    end
  end
end
