require 'test_helper'
require 'paramesan'
require 'logue'
require 'dupless/mockfile'

Logue::Log::level = Logue::Level::DEBUG

module Dupless
  class TestCase < Minitest::Test
    include Paramesan
    include Logue::Loggable
    extend Logue::Loggable

    def self.mockfile size, bytes, checksum
      MockFile.create size, bytes, checksum
    end
  end
end
