require 'pathname'

module Dupless
  class FileDirProcessor
    def initialize args
      @verbose = false
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
        puts "skipping symlink: #{pn}" if @verbose
      elsif pn.pipe?
        puts "skipping pipe: #{pn}" if @verbose
      elsif pn.socket?
        puts "skipping socket: #{pn}" if @verbose
      elsif pn.exist?
        puts "unknown type: #{pn}" if @verbose
      else
        # puts "skipping non-existing elment: #{pn}"
      end
    end

    def process_directory dir
      dir.each_child.to_a.sort.each do |child|
        process child
      end
    end

    def process_file file 
    end
  end
end
