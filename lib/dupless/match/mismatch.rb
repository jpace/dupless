# -*- ruby -*-

require 'dupless/match/base'

module Dupless::Match
  class Mismatch < Base
    attr_reader :common
    attr_reader :x_only
    attr_reader :y_only
    
    def initialize x, y, x_only, common, y_only
      super(x, y)
      @x_only = x_only
      @common = common
      @y_only = y_only
    end

    def type
      :mismatch
    end

    def write
      puts "mismatch"
      puts "x     : #{x.pathname}"
      puts "y     : #{y.pathname}"
      write_files "x only", x, x_only
      write_files "y only", y, y_only
      puts "common"
      common.each do |elmt|
        puts "    #{elmt.first}"
        puts "    #{elmt.last}"
      end
    end

    def write_files name, dir, files
      puts name
      files.sort_by(&:pathname).each do |file|
        fname = file.to_s.sub dir.pathname.to_s, "..."
        puts "    #{fname}"
      end
    end

    def write_file dir, file
      name = file.to_s.sub dir.pathname.to_s, "..."
      puts "    #{name}"
    end
  end
end
