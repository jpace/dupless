require 'dupless/dir/match/base'

module Dupless::Match
  class Contains < Base
    attr_reader :common
    attr_reader :only
    
    def initialize x, y, only, common
      super(x, y)
      @only = only
      @common = common
    end

    def write format: nil
      puts type.to_s.gsub '_', ' '
      
      puts "x     : #{x.pathname}"
      puts "y     : #{y.pathname}"
      write_only
      puts "common"
      bypn = Hash.new
               
      common.each do |elmt|
        bypn[elmt.first.pathname] = elmt
      end

      bypn.sort.each do |pn, elmt|
        println elmt.first.to_s, elmt.last.to_s, 50
        printf "    %-65s ... %s\n", elmt.first, elmt.last
      end
    end
  end
  
  class XContainsY < Contains
    def type
      :x_contains_y
    end

    def write_only
      write_files "x only", x, only
    end
  end

  class YContainsX < Contains
    def type
      :y_contains_x
    end

    def write_only
      write_files "y only", y, only
    end
  end
end
