require 'dupless/file/file'

module Dupless
  class MockFile < File
    attr_reader :fname, :size, :checksum

    class << self
      def create size, bytes, checksum
        fname = [ size, bytes, checksum ].join "-"
        MockFile.new fname, size, bytes, checksum
      end
    end
    
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
  
  class MockFiles
    def self.mockfile size, bytes, checksum
      fname = [ size, bytes, checksum ].join "-"
      MockFile.new fname, size, bytes, checksum
    end

    def self.file ary, size, bytes, checksum
      ary << mockfile(size, bytes, checksum)
    end

    def self.files
      @@files ||= Array.new.tap do |a|
        file a, 1, "x", 7
        file a, 2, "x", 7
        file a, 1, "y", 7
        file a, 1, "x", 8
        file a, 1, "x", 7
        file a, 2, "x", 7
        file a, 1, "x", 7
      end
    end

    def self.dir hash, name, *children
      hash[name] = Directory.new name, *children
    end

    def self.directories
      @@directories ||= Hash.new.tap do |h|
        dir h, "a-b", a, b
        dir h, "a-b", a, b
        dir h, "b-a", b, a
        dir h, "a-c", a, c
        dir h, "a-b-c", a, b, c
        dir h, "empty-1"
        dir h, "empty-2"
      end
    end
  end
end
