require 'dupless/dirs/match/strategy'
require 'dupless/dir/directory'
require 'dupless/dirs/match/tc'

module Dupless::Dirs::MatchStrategy
  class Test < Dupless::Match::TestCase
    def self.match_fields common: Array.new, x_only: Array.new, y_only: Array.new
      Dupless::Dirs::MatchFields.new common: common, x_only: x_only, y_only: y_only
    end

    def self.build_params
      params = Array.new

      # identical
      exp = match_fields common: [ [ Files::X17, Files::X17 ], [ Files::X27, Files::X27 ] ]
      params << [ exp, exp, Dirs::X17_X27_1, Dirs::X17_X27_2 ]
      params << [ exp, exp, Dirs::X17_X27_2, Dirs::X17_X27_1 ]

      # overlap/mismatch
      exp = match_fields common: [ [ Files::X17, Files::X17 ] ], x_only: [ Files::X27 ], y_only: [ Files::Y17 ]
      params << [ exp, nil, Dirs::X17_X27_1, Dirs::X17_Y17_1 ]

      # nothing common
      params << [ nil, nil, Dirs::X17_1, Dirs::X27_1 ]
      
      # both empty
      params << [ nil, nil, Dirs::EMPTY1, Dirs::EMPTY2 ]
    end

    param_test build_params.each do |exp_complete, exp_identical, x, y|
      obj = Complete.new
      result = obj.match x, y
      if exp_complete
        assert_equal exp_complete, result
      else
        assert_nil result
      end
    end
    
    param_test build_params.each do |exp_complete, exp_identical, x, y|
      obj = IdenticalOnly.new
      result = obj.match x, y
      if exp_identical
        assert_equal exp_identical, result
      else
        assert_nil result
      end
    end
  end
end
