require 'dupless/set/factory'
require 'dupless/set/base'
require 'dupless/file'
require 'dupless/entry'
require 'dupless/tc'
require 'dupless/mockfiles'

module Dupless
  class SetTest < TestCase
    def self.files
      Dupless::MockFiles.files
    end

    def self.set range, type: :sorted_by_size
      sf = Set::Factory.new
      set = sf.set type: type
      files[range].each do |f|
        set << f
      end
      set
    end

    def self.entry(*indices)
      Dupless::Entry.new(indices.collect { |idx| files[idx] })
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