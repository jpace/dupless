require 'dupless/set/base'

module Dupless::Set
  class SinglePass < Base
    def initialize files: Array.new, matcher: nil
      super matcher: matcher
      
      now = Time.now
      info "init: #{now}"
      
      @size_to_files = Hash.new { |h, k| h[k] = Array.new }
      files.each do |f|
        @size_to_files[f.size] << f
      end

      info "added: #{Time.now}"
    end

    def << obj
      @size_to_files[obj.size] << obj
    end
    
    def execute
      info "@size_to_files.keys.size: #{@size_to_files.keys.size}"

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
            if x.match? y
              dup = add_duplicate dup, x, y
              files[j] = nil
            end
          end
        end
      end
    end

    def to_s
      "#keys: #{@size_to_files.keys.size}"
    end
  end
end
