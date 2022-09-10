require 'dupless/file/file'

module Dupless
  class MockFile < File
    attr_reader :fname, :size, :checksum

    def initialize bytes, size, checksum
      @fname = [ bytes, size, checksum ].join "-"
      # need to call the super ctor before setting the size, since the values would clash (nil in
      # the superctor, since there is no such file)
      super @fname
      
      @size = size
      @bytes = bytes
      @checksum = checksum
    end

    def bytes num
      @bytes[0 ... num]
    end
  end
end
