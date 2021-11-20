require 'dupless/dirs/match/mismatch'
require 'dupless/dirs/match/tc'

module Dupless::Match
  class MismatchTest < TestCase
    def run_test index, field
      args = [ Dirs::X17_X27_1, Dirs::X17_Y17_1, Array[Files::X27], [[Files::X17, Files::X17]], Array[Files::Y17] ]
      match = Mismatch.new(*args)
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
    
    def test_x_only
      run_test 2, :x_only
    end
    
    def test_common
      run_test 3, :common
    end
    
    def test_y_only
      run_test 4, :y_only
    end
  end
end
