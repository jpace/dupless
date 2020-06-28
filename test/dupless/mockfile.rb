require 'dupless/file'

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
end
