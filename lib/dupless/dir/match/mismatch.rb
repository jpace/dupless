require 'dupless/dir/match/base'

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

    def write format: nil
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
  end
end
