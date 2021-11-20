require 'test_helper'
require 'paramesan'
require 'logue/log'
require 'logue/loggable'
require 'dupless/mockfiles'
require 'dupless/dir/directory'

Logue::Log::level = Logue::Level::DEBUG

module Dupless
  class TestCase < Minitest::Test
    include Paramesan
    include Logue::Loggable
    extend Logue::Loggable

    module Files
      def self.mockfile size, bytes, checksum
        MockFile.create size, bytes, checksum
      end
      
      X17 = mockfile 1, "x", 7
      X27 = mockfile 2, "x", 7
      Y17 = mockfile 1, "y", 7
      X18 = mockfile 1, "x", 8
      Z39 = mockfile 3, "z", 9
    end      

    module Dirs
      def self.directory name, *children
        Dupless::Directory.new name, children
      end

      X17_X27_1 = directory "X17_X27_1", Files::X17, Files::X27
      X17_X27_2 = directory "X17_X27_2", Files::X17, Files::X27
      X17_Y17_1 = directory "X17_Y17_1", Files::X17, Files::Y17
      X17_1 = directory "X17_1", Files::X17
      X27_1 = directory "X27_1", Files::X27
      EMPTY1 = directory "empty-1"
      EMPTY2 = directory "empty-2"  
    end
  end
end
