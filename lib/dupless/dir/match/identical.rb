require 'dupless/dir/match/base'

module Dupless::Match
  class Identical < Base
    attr_reader :common
    
    def initialize x, y, common
      super(x, y)
      @common = common
    end

    def type
      :identical
    end

    def write format: nil
      puts "identical"
      puts "x     \"#{x.pathname}\""
      puts "y     \"#{y.pathname}\""
      if format == :sizes
        puts "x.size #{x.pathname.children.size}"
        puts "y.size #{y.pathname.children.size}"
      elsif format == :summary
      else
        puts "common"
        common.each do |elmt|
          println elmt.first.to_s, elmt.last.to_s, 50
        end
      end
    end
  end
end
