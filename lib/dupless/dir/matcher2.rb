require 'dupless/file/file'
require 'dupless/dir/directory'
require 'dupless/dir/matcher'
require 'logue/loggable'

module Dupless
  class Matcher2
    include Logue::Loggable

    def initialize dirs
      @dirs = dirs
    end

    def dir_files dir
      dir.children.select(&:file?).collect { |child| Dupless::File.new child }
    end

    # optimize for identical (same # of files)
    # for x includes y (x.size > y.size)
    # for y includes x (y.size > x.size)
    
    def duplicates filter: Array.new, formatter: nil
      matcher = Matcher.new
      @dirs.sort.each do |xname, others|
        xfiles = dir_files xname
        xdir = Directory.new xname, xfiles
        others.each do |yname|
          yfiles = dir_files yname
          ydir = Directory.new yname, yfiles
          match = matcher.create xdir, ydir

          if match && (filter.nil? || filter.empty? || filter.include?(match.class))
            puts "match: #{match.class}"
            match.write formatter: formatter
          end
        end
      end
      nil
    end
  end
end
