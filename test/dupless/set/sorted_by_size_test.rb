require 'dupless/set/sorted_by_size'
require 'dupless/set/tc'

module Dupless::Set
  class SortedBySizeTest < TestCase
    def self.set_class
      SortedBySize
    end

    param_test dups_build_params.each do |expected, set|
      set.run
      result = set.matcher.duplicates
      assert_equal expected, result
    end
  end
end
