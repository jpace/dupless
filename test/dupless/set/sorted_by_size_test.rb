require 'dupless/set/sorted_by_size'
require 'dupless/set/tc'

module Dupless::Set
  class SortedBySizeTest < TestCase
    def self.files
      Dupless::MockFiles.files
    end

    def self.set range
      SortedBySize.new files: files[range]
    end

    def self.dups_build_params
      Array.new.tap do |ary|
        ary << [ Array.new, set(0 .. 3) ]
        ary << [ [ entry(0, 4) ], set(0 .. 4) ]
        ary << [ [ entry(0, 4) ], set(0 .. 4) ]
        ary << [ [ entry(0, 4), entry(1, 5) ], set(0 .. 5) ]
        ary << [ [ entry(0, 4, 6), entry(1, 5) ], set(0 .. 6) ]
      end
    end

    param_test dups_build_params.each do |expected, set|
      result = set.entries
      assert_equal expected, result
    end
  end
end
