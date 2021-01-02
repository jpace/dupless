require 'pathname'

module Dupless
  class Directory
    attr_reader :pathname
    
    def initialize what, children = nil
      @pathname = what.kind_of?(Pathname) ? what : Pathname.new(what)
      @children = children
    end

    def children
      @children ||= @pathname.children
    end

    def to_s
      @pathname.to_s + "; #children: " + @children.size.to_s
    end

    def inspect
      to_s
    end
  end
end
