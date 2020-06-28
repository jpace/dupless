# -*- ruby -*-

require 'pathname'
require 'digest/md5'

module Dupless
  class File
    include Comparable
    
    attr_reader :pathname
    
    def initialize what
      @pathname = what.kind_of?(Pathname) ? what : Pathname.new(what)
      @size = nil
      @bytes = nil
      @checksum = nil
    end

    def size
      @size ||= @pathname.size
    end

    def bytes num
      @pathname.read num
    end

    def checksum
      @checksum ||= Digest::MD5.hexdigest(@pathname.read)
    end

    def <=> other
      comps = Array.new.tap do |a|
        a << Proc.new { size <=> other.size }
        a << Proc.new { nbytes = 10; bytes(nbytes) <=> other.bytes(nbytes) }
        a << Proc.new { checksum <=> other.checksum }
      end

      (0 ... comps.size - 1).each do |idx|
        cmp = comps[idx].call
        return cmp if cmp.nonzero?
      end

      comps.last.call
    end

    def match? other
      self == other
    end

    def to_s
      pathname.to_s
    end
  end
end
