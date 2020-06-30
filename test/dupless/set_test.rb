require 'test_helper'
require 'dupless/set_factory'
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

    def self.set range, type: :sorted_by_size
      sf = SetFactory.new
      set = sf.set type: type
      files[range].each do |f|
        set << f
      end
      set
    end

    def self.entry(*indices)
      Entry.new(indices.collect { |idx| files[idx] })
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
      puts "dups: #{dups}"
      assert_equal exp, dups
    end

    def self.performance_build_params
      Array.new.tap do |ary|
        ary << [ Array.new, set(0 .. 3) ]
        ary << [ [ entry(0, 4) ], set(0 .. 4) ]
        ary << [ [ entry(0, 4) ], set(0 .. 4) ]
        ary << [ [ entry(0, 4), entry(1, 5) ], set(0 .. 5) ]
        ary << [ [ entry(0, 4, 6), entry(1, 5) ], set(0 .. 6) ]
      end
    end

    # param_test performance_build_params.each do |exp, set|
    #   dups = set.duplicates
    #   puts "dups: #{dups}"
    #   assert_equal exp, dups
    # end
  end
end
