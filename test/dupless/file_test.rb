require 'test_helper'
require 'dupless/file'
require 'paramesan'
require 'digest/md5'

module Dupless
  class MockFile < File
    attr_reader :fname, :size, :checksum
    
    def initialize fname, size, bytes, checksum
      super fname
      
      @fname = fname
      @size = size
      @bytes = bytes
      @checksum = checksum
    end

    def bytes num
      @bytes[0 ... num]
    end
  end

  class FileTest < Minitest::Test
    include Paramesan

    def self.build_params
      a = MockFile.new "", 1, "x", 7
      b = MockFile.new "", 2, "x", 7
      c = MockFile.new "", 1, "y", 7
      d = MockFile.new "", 1, "x", 8
      
      [
        [  0, a, a ],
        [ -1, a, b ],
        [  1, b, a ],
        [ -1, a, c ],
        [  1, c, a ],
        [ -1, a, d ],
        [  1, d, a ],
      ]
    end

    param_test build_params.each do |exp, x, y|
      result = x <=> y
      assert_equal exp, result
    end
  end
end
