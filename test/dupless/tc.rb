require 'test_helper'
require 'paramesan'
require 'logue/log'
require 'logue/loggable'
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
      
      X17 = find_by_path "1", "X17", "x-1-7"
      X27 = find_by_path "1", "X27", "x-2-7"
      Y17 = find_by_path "1", "X17-Y17", "y-1-7"
      X18 = find_by_path "1", "X18", "x-1-8"
      Z39 = find_by_path "1", "Z39", "z-3-9"
    end

    module Dirs
      extend Resources
      
      X17_X27_1 = find_by_path "1", "X17-X27"
      X17_X27_2 = find_by_path "2", "X17-X27"
      X17_Y17_1 = find_by_path "1", "X17-Y17"
      X17_1 = find_by_path "1", "X17"
      X27_1 = find_by_path "1", "X27"
      EMPTY1 = find_by_path "empty1"
      EMPTY2 = find_by_path "empty2"  
    end
  end
end
