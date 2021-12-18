require 'test_helper'
require 'paramesan'
require 'logue/log'
require 'logue/loggable'
require 'dupless/mockfiles'
require 'dupless/dir/directory'
require 'resources'

Logue::Log::level = Logue::Level::DEBUG

module Dupless
  class TestCase < Minitest::Test
    include Paramesan
    include Resources
    include Logue::Loggable
    extend Logue::Loggable

    module Files
      extend Resources
      
      def self.mockfile size, bytes, checksum
        MockFile.create size, bytes, checksum
      end

      X17 = find_by_path "X17-X27-1", "1-x-7"
      X27 = find_by_path "X17-X27-1", "2-x-7"
      Y17 = find_by_path "X17-Y17-1", "1-y-7"
      X18 = find_by_path "X18-1", "1-x-8"
      Z39 = find_by_path "Z39-1", "3-z-9"
    end      

    module Dirs
      extend Resources
      
      X17_X27_1 = find_by_path "X17-X27-1"
      X17_X27_2 = find_by_path "X17-X27-2"
      X17_Y17_1 = find_by_path "X17-Y17-1"
      X17_1 = find_by_path "X17-1"
      X27_1 = find_by_path "X27-1"
      EMPTY1 = find_by_path "empty-1"
      EMPTY2 = find_by_path "empty-2"  
    end
  end
end
