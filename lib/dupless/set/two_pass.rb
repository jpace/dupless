#!/usr/bin/env ruby
# -*- ruby -*-

require 'dupless/set/files'

module Dupless::Set
  class TwoPassSet < WithFiles
    def duplicates
      # almost completely unoptimized:

      start = Time.now
      info "start: #{start}"
      
      dups = Array.new
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
            dup ||= Dupless::Entry.new([x])
            dup << y
            @files[j] = nil
          end
        end
        if dup
          dups << dup
        end
      end

      done = Time.now
      info "done: #{done}"

      diff = done - start
      info "diff: #{diff}"
      
      dups
    end
  end
end
