require 'pathname'

module Dupless
  module TreeNodes
  end
end

module Dupless::TreeNodes
  class FileNode < Pathname
    def initialize pn
      super pn
    end
    
    def file?
      true
    end

    def height
      0
    end
  end

  class BaseDir
    attr_reader :pathname
    
    def initialize what
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

  class EmptyDir < BaseDir
    def empty?
      true
    end

    def height
      0
    end
  end

  class ParentDir < BaseDir
    def empty?
      false
    end
    
    def initialize what, children = nil
      super what
      @children = children
    end

    def make_empty dir
      EmptyDir.new dir
    end

    def make_parent dir
      ParentDir.new dir
    end

    def make_file file
      FileNode.new file
    end

    def make_directory dir
      if Dir.empty? dir
        make_empty dir
      else
        make_parent dir
      end
    end

    def basename
      @pathname.basename
    end

    def basenames
      @basenames ||= children.map(&:basename).sort
    end
    
    def children
      # not reevaluating this every time against Pathname, because that doesn't
      # mementoize the value.
      @children ||= @pathname.children.collect do |kid|
        if kid.directory?
          if false && Dir.empty?(kid)
            EmptyDir.new kid
          else
            ParentDir.new kid
          end
        else
          FileNode.new kid
        end
      end
    end
    
    def count
      @count ||= children.size
    end    

    def height
      @height ||= begin
                    1 + (children.collect { |kid| kid.height }.max || 0)
                  end
    end
  end

  class TreeWalker
    # sort: process children in a directory in sorted order;
    #       adds about 15% to processing time.
    def initialize(*args, sort: false, verbose: false)
      @verbose = verbose
      @processor = if sort
                     Proc.new { |dir| dir.children.sort }
                   else
                     Proc.new { |dir| dir.children }
                   end
      args.each do |arg|
        process arg
      end
    end

    def process what
      if what.directory?
        process_directory what
      elsif what.file?
        process_file what
      else
        printmsg { "skipping unhandled element: #{what}" }
      end
    end

    def process_directory dir
      @processor.call(dir).each do |child|
        process child
      end
    end

    def process_file file
    end

    def printmsg(&blk)
      if @verbose
        puts blk.call
      end
    end
  end
end
