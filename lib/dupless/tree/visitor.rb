require 'dupless/tree/nodes'

module Dupless
  module TreeNodes
  end
end

module Dupless::TreeNodes
  class Visitor
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
