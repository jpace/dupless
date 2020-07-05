require 'dupless/set/singlepass'
require 'dupless/file'
require 'dupless/entry'
require 'dupless/set/tc'

Logue::Log::level = Logue::Level::DEBUG

module Dupless::Set
  class SinglePassTest < TestCase
    def self.set range
      SinglePass.new files: files[range]
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

    param_test dups_build_params.each do |exp, set|
      dups = set.duplicates
      assert_equal exp, dups
    end
  end
end
