require 'dupless/set/sorted_by_size'
require 'dupless/set/tc'

module Dupless::Set
  class SortedBySizeTest < TestCase
    def self.set range
      SortedBySize.new files: files[range], matcher: Dupless::FileMatcher.new
    end

    def self.dups_build_params
      Array.new.tap do |ary|
        ary << [ Array.new, set(0 .. 3) ]
        ary << [ [ dupfiles(0, 4) ], set(0 .. 4) ]
        ary << [ [ dupfiles(0, 4) ], set(0 .. 4) ]
        ary << [ [ dupfiles(0, 4), dupfiles(1, 5) ], set(0 .. 5) ]
        ary << [ [ dupfiles(0, 4, 6), dupfiles(1, 5) ], set(0 .. 6) ]
      end
    end

    param_test dups_build_params.each do |expected, set|
      set.run
      result = set.matcher.duplicates
      assert_equal expected, result
    end
  end
end
