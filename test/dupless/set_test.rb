require 'test_helper'
require 'dupless/set'
require 'dupless/file'
require 'dupless/entry'
require 'dupless/mockfiles'
require 'paramesan'
require 'logue'

Logue::Log::level = Logue::Level::DEBUG

module Dupless
  class SetTest < Minitest::Test
    include Paramesan
    include Logue::Loggable

    def self.files
      MockFiles.files
    end

    def self.set range
      Set.new files[range]
    end

    def self.entry(*indices)
      Entry.new(indices.collect { |idx| files[idx] })
    end

    def self.dups_build_params
      Array.new.tap do |ary|
        ary << [ Array.new, set(0 .. 3) ]
        ary << [ [ entry(0, 4) ], set(0 .. 4) ]
        ary << [ [ entry(0, 4) ], set(0 .. 4) ]
      end
    end

    param_test dups_build_params.each do |exp, set|
      dups = set.duplicates
      assert_equal exp, dups
    end
  end
end
