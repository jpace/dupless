require 'test_helper'
require 'paramesan'
require 'logue/log'
require 'logue/loggable'
require 'dupless/mockfiles'

Logue::Log::level = Logue::Level::DEBUG

module Dupless
  class TestCase < Minitest::Test
    include Paramesan
    include Logue::Loggable
    extend Logue::Loggable

    def self.mockfile size, bytes, checksum
      MockFile.create size, bytes, checksum
    end

    def self.directory name, *children
      Dupless::Directory.new name, children
    end
    
    F1 = mockfile 1, "x", 7
    F2 = mockfile 2, "x", 7
    F3 = mockfile 1, "y", 7
    F4 = mockfile 1, "x", 8
    F5 = mockfile 3, "z", 9

    D1 = directory "F1-F2",    F1, F2
    D2 = directory "F1-F2",    F1, F2
    D3 = directory "F2-F1",    F2, F1
    D4 = directory "F1-F3",    F1, F3
    D5 = directory "F1-F2-F3", F1, F2, F3
    D6 = directory "empty-1"
    D7 = directory "empty-2"  
    D8 = directory "F2-F1",    F1, F5
  end
end
