require 'dupless/tc'
require 'dupless/file/filematcher'

module Dupless::Set
  class TestCase < Dupless::TestCase
    def self.set files
      set_class.new files: files, matcher: Dupless::FileMatcher.new
    end
    
    include Files
    include Dirs

    def self.dups_build_params
      Array.new.tap do |ary|
        ary << [ [],                                           set([X17, X27, Y17, X18]) ]
        ary << [ [ [ X17, X17 ] ],                             set([X17, X27, Y17, X18, X17]) ]
        ary << [ [ [ X17, X17 ], [ X27, X27 ] ],               set([X17, X27, Y17, X18, X17, X27]) ]
        ary << [ [ [ X17, X17 ], [ Y17, Y17 ], [ X27, X27 ] ], set([X17, X27, Y17, X18, X17, X27, Y17]) ]
      end
    end
  end
end
