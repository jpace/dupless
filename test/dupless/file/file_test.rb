require 'dupless/file/file'
require 'dupless/tc'

module Dupless
  class FileTest < TestCase
    def self.build_params
      include Files
      [
        [  0, X17, X17 ],
        [ -1, X17, X27 ],
        [  1, X27, X17 ],
        [ -1, X17, Y17 ],
        [  1, Y17, X17 ],
        [ -1, X17, X18 ],
        [  1, X18, X17 ],
        [  0, X17, X17.dup ],
      ]
    end

    param_test build_params.each do |exp, x, y|
      result = x <=> y
      assert_equal exp, result
    end

    param_test build_params.each do |exp, x, y|
      result = x == y
      assert_equal exp == 0, result
    end
  end
end
