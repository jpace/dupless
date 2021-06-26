require 'dupless/dir/directory'
require 'dupless/mockfile'
require 'dupless/tc'

module Dupless::Match
  class TestCase < Dupless::TestCase
    def self.directory name, *children
      Dupless::Directory.new name, children
    end
    
    F1 = mockfile 1, "x", 7
    F2 = mockfile 2, "x", 7
    F3 = mockfile 1, "y", 7
    F4 = mockfile 1, "x", 8
    F5 = mockfile 3, "z", 9

    D1 = directory "F1-F2",    [ F1, F2 ]
    D2 = directory "F1-F2",    [ F1, F2 ]
    D3 = directory "F2-F1",    [ F2, F1 ]
    D4 = directory "F1-F3",    [ F1, F3 ]
    D5 = directory "F1-F2-F3", [ F1, F2, F3 ]
    D6 = directory "empty-1",  [ ]
    D7 = directory "empty-2",  [ ]
  end
end
