#!/usr/bin/env ruby
# -*- ruby -*-

require 'dupless/set/base'

module Dupless::Set
  class SinglePass < Base
    def initialize files: Array.new
      now = Time.now
      info "init: #{now}"
      
      @by_size = Hash.new { |h, k| h[k] = Array.new }
      files.each do |f|
        @by_size[f.size] << f
      end
    end

    def << obj
      @by_size[obj.size] << obj
    end
    
    def duplicates
      start = Time.now
      info "start: #{start}"
      
      dups = Array.new

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
              dup ||= Dupless::Entry.new([x])
              dup << y
              files[j] = nil
            end
          end
          if dup
            dups << dup
          end
        end
      end

      done = Time.now
      info "done: #{done}"

      diff = done - start
      info "diff: #{diff}"
      
      dups
    end

    def to_s
      "by_size.keys.size: #{@by_size.keys.size}"
    end
  end
end
