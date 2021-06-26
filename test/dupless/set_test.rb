require 'dupless/set/factory'
require 'dupless/file/dupfiles'
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

    def self.dupfiles(*indices)
      Dupless::DuplicateFiles.new(indices.collect { |idx| files[idx] })
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

    if false
      param_test dups_build_params.each do |exp, set|
        dups = set.duplicates
        assert_equal exp, dups
      end
    end

    def self.dir_file dir, size, bytes, checksum
      fname = [ size, bytes, checksum ].join "-"
      fullname = dir + "/" + fname
      MockFile.new fullname, size, bytes, checksum
    end

    def self.dir_dups_build_params
      sf = Set::Factory.new
      set = sf.set type: :sorted_by_size
      files = Array.new
      files << dir_file("d1", 1, "x", 7)
      files << dir_file("d2", 1, "x", 7)
      files.each do |f|
        set << f
      end
      
      Array.new.tap do |ary|
        ary << [ Array.new, set ]
      end
    end

    if false
      param_test dir_dups_build_params.each do |expected, set|
        dirs = set.directories
        result = Dupless::Directories.new(dirs).duplicates filter: nil
        assert_equal expected, result
      end
    end
  end
end
