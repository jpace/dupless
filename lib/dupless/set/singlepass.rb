require 'dupless/set/base'
require 'dupless/util/timer'

module Dupless::Set
  class SinglePass < Base
    def initialize files: Array.new, matcher: nil
      super matcher: matcher
      # can do group_by or Hash(Array default), but not both:
      Dupless::Timer.new.debug do
        @size_to_files = files.group_by(&:size)
      end
    end

    def << file
      (@size_to_files[file.size] ||= Array.new) << file
    end
    
    def execute
      @size_to_files.each do |size, files|
        nfiles = files.size
        next if nfiles < 2
        (0 ... nfiles - 1).each do |i|
          x = files[i]
          next if x.nil?
          dup = nil
          (i + 1 ... nfiles).each do |j|
            y = files[j]
            next if y.nil?
            if x == y
              dup = add_duplicate dup, x, y
              files[j] = nil
            end
          end
        end
      end
    end

    def to_s
      @size_to_files.to_s
    end
  end
end
