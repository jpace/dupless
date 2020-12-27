require 'logue/loggable'

module Dupless
  module Match
  end
end

module Dupless::Match
  class Base
    include Logue::Loggable

    attr_reader :x
    attr_reader :y
    
    def initialize x, y
      @x = x
      @y = y
    end

    def to_s
      "type: #{type}"
    end

    def inspect
      to_s
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

    def println from, to, width
      str = from[0 ... width]
      str << " "
      str << ("." * ([ 0, width - from.length ].max))
      str << " == "
      str << to
      puts str
    end
  end
end
