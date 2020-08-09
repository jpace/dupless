#!/usr/bin/env ruby

require 'pathname'

module Dupless
  class FileDirProcessor
    def initialize args
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
      elsif pn.exist?
        puts "unknown type: #{pn}"
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
