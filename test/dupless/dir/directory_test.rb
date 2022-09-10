require 'dupless/dir/directory'
require 'dupless/tc'

module Dupless
  class DirectoryTest < TestCase
    def self.build_children_params
      [
        [ [ Files::X17, Files::X27 ], Dirs::X17_X27_1 ],
        [ [ Files::X17 ], Dirs::X17_1 ]
      ]
    end

    param_test build_children_params.each do |exp, dir|
      result = dir.children
      assert_equal exp, result
    end

    def self.build_count_params
      [
        [ 2, Dirs::X17_X27_1 ],
        [ 1, Dirs::X17_1 ]
      ]
    end

    param_test build_count_params.each do |exp, dir|
      result = dir.count
      assert_equal exp, result
    end

    def self.build_basename_params
      [
        [ [ Files::X17.basename, Files::X27.basename ], Dirs::X17_X27_1 ],
        [ [ Files::X17.basename ], Dirs::X17_1 ],
      ]
    end

    param_test build_basename_params.each do |exp, dir|
      result = dir.basenames
      assert_equal exp, result
    end
  end
end
