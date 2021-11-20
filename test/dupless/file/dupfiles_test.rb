require 'dupless/file/dupfiles'
require 'dupless/tc'

module Dupless
  class DuplicateFilesTest < TestCase
    @@mockfiles = Array.new.tap do |ary|
      ary << Files::X17
      ary << Files::X27
      ary << Files::Y17
      ary << Files::X18
      ary << Files::X17
    end

    def self.files
      @@mockfiles
    end
    
    def self.files_size_build_params
      Array.new.tap do |ary|
        ary << [ 1, DuplicateFiles.new(files[0 .. 0]) ]
        ary << [ 4, DuplicateFiles.new(files[0 .. 3]) ]
        ary << [ 5, DuplicateFiles.new(files[0 .. 4]) ]
      end
    end

    param_test files_size_build_params.each do |exp, dupfiles|
      result = dupfiles.files.size
      assert_equal exp, result
    end

    def self.files_index_build_params
      Array.new.tap do |ary|
        ary << [ files[0], 0, DuplicateFiles.new(files[0 .. 0]) ]
        ary << [ files[0], 0, DuplicateFiles.new(files[0 .. 1]) ]
        ary << [ files[1], 1, DuplicateFiles.new(files[0 .. 1]) ]
      end
    end

    param_test files_index_build_params.each do |exp, idx, dupfiles|
      result = dupfiles.files[idx]
      assert_equal exp, result
    end
  end
end
