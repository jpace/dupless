require 'dupless/mockfile'

module Dupless
  class MockFiles
    @@files = Array.new.tap do |ary|
      ary << MockFile.new("1-x-7", 1, "x", 7)
      ary << MockFile.new("2-x-7", 2, "x", 7)
      ary << MockFile.new("1-y-7", 1, "y", 7)
      ary << MockFile.new("1-x-8", 1, "x", 8)
      ary << MockFile.new("1-x-7", 1, "x", 7)
      ary << MockFile.new("2-x-7", 2, "x", 7)
      ary << MockFile.new("1-x-7", 1, "x", 7)
    end

    def self.files
      @@files
    end
  end
end
