require 'dupless/file/file'
require 'pathname'

module Dupless
  class BaseDirectory
    attr_reader :pathname
    
    def initialize what, children = nil
      @pathname = what.kind_of?(Pathname) ? what : Pathname.new(what)
    end

    def directory?
      true
    end

    def to_s
      @pathname.to_s
    end

    def basename
      @pathname.basename
    end

    def inspect
      to_s
    end
  end

  class Directory < BaseDirectory
    attr_reader :pathname
    
    def initialize what, children = nil
      @pathname = what.kind_of?(Pathname) ? what : Pathname.new(what)
      @children = children
      @is_empty = nil
    end

    def children
      # not reevaluating this every time against Pathname, because that doesn't
      # mementoize the value.
      @children ||= @pathname.children.collect do |a|
        if a.directory?
          Directory.new a
        else
          Dupless::File.new a
        end
      end
    end

    def empty?
      if @is_empty.nil?
        @is_empty = Dir.empty? @pathname
      end
      @is_empty
    end
    
    def count
      @count ||= children.size
    end    

    def to_s
      @pathname.to_s + "; #children: " + children.size.to_s
    end

    def basenames
      @basenames ||= children.map(&:basename).sort
    end

    def height
      @height ||= (children.empty? ? 0 : 1 + @children.collect { |kid| kid.height }.max)
    end
  end
end
