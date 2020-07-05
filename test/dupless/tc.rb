require 'test_helper'
require 'paramesan'
require 'logue'

Logue::Log::level = Logue::Level::DEBUG

module Dupless
  class TestCase < Minitest::Test
    include Paramesan
    include Logue::Loggable
    extend Logue::Loggable

  end
end
