require 'pathname'

module Dupless
  class FileDirProcessor
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
        pn = arg.kind_of?(Pathname) ? arg : Pathname.new(arg)
        process pn
      end
    end

    def process pn
      if pn.directory?
        process_directory pn
      elsif pn.file?
        process_file pn
      elsif pn.symlink?
        printmsg { "skipping symlink: #{pn}" }
      elsif pn.pipe?
        printmsg { "skipping pipe: #{pn}" }
      elsif pn.socket?
        printmsg { "skipping socket: #{pn}" }
      elsif pn.exist?
        printmsg { "unknown type: #{pn}" }
      else
        printmsg { "skipping non-existing element: #{pn}" }
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
