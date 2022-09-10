require 'dupless/set/base'

module Dupless::Set
  class TwoPass < WithFiles
    def execute
      # almost completely unoptimized:      
      nfiles = @files.size
      (0 ... nfiles).each do |i|
        x = @files[i]
        next if x.nil?
        dup = nil
        (0 ... nfiles).each do |j|
          next if i == j
          y = @files[j]
          next if y.nil?
          if x == y
            dup = add_duplicate dup, x, y
            @files[j] = nil
          end
        end
      end
    end
  end
end
