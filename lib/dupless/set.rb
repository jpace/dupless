# -*- ruby -*-

require 'dupless/file'
require 'dupless/entry'
require 'logue'

module Dupless
  class Set
    include Logue::Loggable

    attr_reader :files
    
    def initialize(enum = nil)
      @files = Array.new
      @files.concat(enum) if enum
    end

    def << obj
      @files << obj
    end

    def duplicates
      # almost completely unoptimized:

      info "now: #{Time.now}"
      
      dups = Array.new
      nfiles = @files.size
      (0 ... nfiles).each do |i|
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

      info "now: #{Time.now}"
      
      dups
    end

    def duplicates_2
      # a little optimized:

      dups = Array.new

      info "now: #{Time.now}"

      by_size = @files.sort_by(&:size)
      # info "by_size: #{by_size}"

      info "now: #{Time.now}"

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

      info "now: #{Time.now}"
      
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
