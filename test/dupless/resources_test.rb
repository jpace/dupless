require 'resources'
require 'dupless/tc'

module Dupless
  class ResourcesTest < TestCase
    param_test [
      [ [ "1", 6 ], "1" ],
      [ [ "X17-Y17", 2 ], "1", "X17-Y17" ],
      [ "1-x-7", "1", "X17-Y17", "1-x-7" ],
      [ "1-y-7", "1", "X17-Y17", "1-y-7" ],
    ] do |exp, *args|
      obj = Object.new
      obj.extend Resources
      result = obj.find_by_path(*args)
      # file or directory
      if exp.kind_of? Array
        assert_kind_of Directory, result
        assert_equal exp.first, result.pathname.basename.to_s
        assert_equal exp.last, result.children.size
      else
        assert_kind_of MockFile, result
        assert_equal exp, result.pathname.basename.to_s
      end
    end
  end
end
