require 'dupless/entry'
require 'dupless/mockfile'
require 'dupless/tc'

module Dupless
  class EntryTest < TestCase
    @@mockfiles = Array.new.tap do |ary|
      ary << MockFile.new("1-x-7", 1, "x", 7)
      ary << MockFile.new("2-x-7", 2, "x", 7)
      ary << MockFile.new("1-y-7", 1, "y", 7)
      ary << MockFile.new("1-x-8", 1, "x", 8)
      ary << MockFile.new("1-x-7", 1, "x", 7)
    end

    def self.files
      @@mockfiles
    end
    
    def self.files_size_build_params
      Array.new.tap do |ary|
        ary << [ 1, Entry.new(files[0 .. 0]) ]
        ary << [ 4, Entry.new(files[0 .. 3]) ]
        ary << [ 5, Entry.new(files[0 .. 4]) ]
      end
    end

    param_test files_size_build_params.each do |exp, entry|
      result = entry.files.size
      assert_equal exp, result
    end

    def self.files_index_build_params
      Array.new.tap do |ary|
        ary << [ files[0], 0, Entry.new(files[0 .. 0]) ]
        ary << [ files[0], 0, Entry.new(files[0 .. 1]) ]
        ary << [ files[1], 1, Entry.new(files[0 .. 1]) ]
      end
    end

    param_test files_index_build_params.each do |exp, idx, entry|
      result = entry.files[idx]
      assert_equal exp, result
    end
  end
end
