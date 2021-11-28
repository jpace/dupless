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
end
