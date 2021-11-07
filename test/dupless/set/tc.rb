require 'dupless/file/dupfiles'
require 'dupless/tc'
require 'dupless/mockfiles'
require 'dupless/file/filematcher'

module Dupless::Set
  class TestCase < Dupless::TestCase
    def self.set range
      set_class.new files: files[range], matcher: Dupless::FileMatcher.new
    end
    
    def self.files
      Dupless::MockFiles.files
    end

    def self.dupfiles(*indices)
      Dupless::DuplicateFiles.new(indices.collect { |idx| files[idx] })
    end

    def self.dups_build_params
      Array.new.tap do |ary|
        ary << [ Array.new, set(0 .. 3) ]
        ary << [ [ dupfiles(0, 4) ], set(0 .. 4) ]
        ary << [ [ dupfiles(0, 4), dupfiles(1, 5) ], set(0 .. 5) ]
        ary << [ [ dupfiles(0, 4, 6), dupfiles(1, 5) ], set(0 .. 6) ]
      end
    end
  end
end
