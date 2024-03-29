require 'dupless/set/base'

module Dupless::Set
  class SortedBySize < WithFiles
    def execute
      debug { "before sort: #{Time.now}" }
      by_size = @files.sort_by(&:size)
      debug { "after sort: #{Time.now}" }

      nfiles = by_size.size
      debug { "nfiles: #{nfiles}" }
      
      (0 ... nfiles).each do |i|
        x = by_size[i]
        next if x.nil?
        dup = nil
        (i + 1 ... nfiles).each do |j|
          y = by_size[j]
          next if y.nil?
          break if y.size > x.size
          if x == y
            dup = add_duplicate dup, x, y
            by_size[j] = nil
          end
        end
      end
    end
  end
end
