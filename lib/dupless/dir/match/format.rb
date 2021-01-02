require 'dupless/dir/match/identical'

module Dupless::Match
  class Formatter
    def write_common match: nil
      puts "common"
      maxwidth = 0
      pathnames = match.common.collect do |elmt|
        x, y = [ elmt.first, elmt.last ].collect { |t| t.pathname.to_s }
        maxwidth = [ maxwidth, x.length ].max
        [ x, y ]
      end
      
      pathnames.sort.each do |elmt|
        println elmt.first, elmt.last, maxwidth + 5
      end
    end
    
    def write_identical match: nil
      puts "identical"
      xpn = match.x.pathname
      ypn = match.y.pathname
      puts "x     \"#{xpn}\""
      puts "y     \"#{ypn}\""
      
      write_common match: match
    end

    def write_files name: nil, dir: nil, files: nil
      puts name
      files.sort_by(&:pathname).each do |file|
        fname = file.to_s.sub dir.pathname.to_s, "..."
        puts "    #{fname}"
      end
    end
    
    def write_mismatch match: nil
      x = match.x
      y = match.y
      puts "mismatch"
      puts "x     : #{x.pathname}"
      puts "y     : #{y.pathname}"
      write_files name: "x only", dir: x, files: match.x_only
      write_files name: "y only", dir: y, files: match.y_only
      write_common match: match
    end
    
    def write_contains match: nil
      x = match.x
      y = match.y
      
      puts "x contains y"
      puts "x     : #{x.pathname}"
      puts "y     : #{y.pathname}"
      write_files name: "x only", dir: x, files: match.only     
      write_common match: match
    end
    
    def println from, to, width
      str = "    "
      str << from[0 ... width]
      str << " "
      str << ("." * ([ 0, width - from.length ].max))
      str << " "
      str << to
      puts str
    end
  end

  class BriefFormatter < Formatter
    def write_identical match: nil
      puts "identical"
      xpn = match.x.pathname
      ypn = match.y.pathname
      puts "x     \"#{xpn}\""
      puts "y     \"#{ypn}\""
#      puts "size: #{xpn.size}"
    end
  end
end
