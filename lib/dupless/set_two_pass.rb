#!/usr/bin/env ruby
# -*- ruby -*-

require 'dupless/file'
require 'dupless/entry'
require 'dupless/set'

 module Dupless
  class TwoPassSet < Set
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
            dup ||= Entry.new([x])
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

    def inspect
      to_s
    end

    def to_s
      "files.size: #{@files.size}"
    end
  end
end
