require 'dupless/dir/match/identical'

module Dupless::Match
  class Formatter
    def write_common match: nil
      puts "    common"
      maxwidth = 0
      fnames = match.common.collect do |elmt|
        x, y = [ elmt.first, elmt.last ].collect { |t| t.pathname.basename.to_s }
        maxwidth = [ maxwidth, x.length ].max
        [ x, y ]
      end

      maxwidth += 5
      
      fnames.sort.each do |elmt|
        from = "x/#{elmt.first}"
        to = "y/#{elmt.last}"
        ndots = [ 0, maxwidth - from.length ].max
        printf "        %s %s %s\n", from[0 ... maxwidth], "." * ndots, to
      end
    end

    def write_xy match: nil
      xpn = match.x.pathname
      ypn = match.y.pathname
      puts "x  \"#{xpn}\""
      puts "y  \"#{ypn}\""
    end
    
    def write_identical match: nil
      puts "identical"
      write_xy match: match      
      write_common match: match
      puts
    end

    def write_files name: nil, files: nil
      puts "    #{name}"
      files.sort_by(&:pathname).each do |file|
        puts "        #{name[0]}/#{file.pathname.basename}"
      end
    end
    
    def write_mismatch match: nil
      puts "mismatch"
      write_xy match: match
      write_files name: "x only", files: match.x_only
      write_files name: "y only", files: match.y_only
      write_common match: match
      puts
    end
    
    def write_contains match: nil
      puts "contains"
      write_xy match: match
      write_files name: "x only", files: match.only     
      write_common match: match
      puts
    end
  end

  class BriefFormatter < Formatter
    def write_identical match: nil
      puts "identical"
      write_xy match: match
      puts
    end
    
    def write_contains match: nil
      puts "contains"
      write_xy match: match
#      write_files name: "x only", files: match.only     
#      write_common match: match
      puts
    end
    
    def write_mismatch match: nil
      puts "mismatch"
      write_xy match: match
      puts "    x only: #{match.x_only.size}"
      puts "    y only: #{match.y_only.size}"
      puts "    common: #{match.common.size}"
      puts
    end
  end
end
