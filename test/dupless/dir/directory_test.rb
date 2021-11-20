require 'dupless/dir/directory'
require 'dupless/tc'

module Dupless
  class DirectoryTest < TestCase
    def self.build_params
      [
        [ [ Files::X17, Files::X27 ], Dirs::X17_X27_1 ],
        [ [ Files::X17 ], Dirs::X17_1 ]
      ]
    end

    param_test build_params.each do |exp, d|
      result = d.children
      assert_equal exp, result
    end
  end
end
