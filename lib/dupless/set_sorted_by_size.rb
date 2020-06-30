#!/usr/bin/env ruby
# -*- ruby -*-

require 'dupless/file'
require 'dupless/entry'
require 'dupless/set'

module Dupless
  class SortedSizeSet < Set
    def duplicates
      # a little optimized:

      dups = Array.new

      start = Time.now
      info "start: #{start}"
      
      by_size = @files.sort_by(&:size)
      # info "by_size: #{by_size}"

      info "after sort: #{Time.now}"

      nfiles = by_size.size
      (0 ... nfiles).each do |i|
        # info "i: #{i}"
        x = by_size[i]
        next if x.nil?
        dup = nil
        (i + 1 ... nfiles).each do |j|
          # info " .. j: #{j}"
          y = by_size[j]
          next if y.nil?
          break if y.size > x.size
          if x.match? y
            dup ||= Entry.new([x])
            dup << y
            by_size[j] = nil
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
