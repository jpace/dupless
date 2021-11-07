require 'dupless/dir/directory'
require 'dupless/tc'

module Dupless
  class DirectoryTest < TestCase
    def self.build_params
      [
        [ [ F1, F2 ], D1 ],
        [ [ F1, F2, F3 ], D5 ],
      ]
    end

    param_test build_params.each do |exp, d|
      result = d.children
      assert_equal exp, result
    end
  end
end
