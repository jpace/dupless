require 'dupless/set/base'

module Dupless::Set
  class SinglePass < Base
    def initialize files: Array.new
      super()
      
      now = Time.now
      info "init: #{now}"
      
      @by_size = Hash.new { |h, k| h[k] = Array.new }
      files.each do |f|
        @by_size[f.size] << f
      end

      info "added: #{Time.now}"
    end

    def << obj
      @by_size[obj.size] << obj
    end
    
    def execute
      info "@by_size.keys.size: #{@by_size.keys.size}"

      @by_size.each do |size, files|
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
      "#keys: #{@by_size.keys.size}"
    end
  end
end
