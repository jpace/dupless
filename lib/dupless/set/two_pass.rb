#!/usr/bin/env ruby
# -*- ruby -*-

require 'dupless/set/files'

module Dupless::Set
  class TwoPass < WithFiles
    def execute
      # almost completely unoptimized:
      
      nfiles = @files.size
      (0 ... nfiles).each do |i|
        # info "#{i}/#{nfiles} - at #{Time.now}"
        
        x = @files[i]
        next if x.nil?
        dup = nil
        (0 ... nfiles).each do |j|
          next if i == j
          y = @files[j]
          next if y.nil?
          if x.match? y
            dup = add_duplicate dup, x, y
            @files[j] = nil
          end
        end
      end
    end
  end
end
