# -*- ruby -*-

require 'dupless/file'
require 'dupless/entry'
require 'dupless/set_two_pass'
require 'dupless/set_sorted_by_size'
require 'logue'

module Dupless
  class SetFactory
    include Logue::Loggable

    attr_reader :files
    
    def set files: Array.new, type: :twopass
      cls = case type
            when :twopass
              TwoPassSet
            when :sorted_by_size
              SortedSizeSet
            else
              raise "unknown set type: #{type.inspect}"
            end
      cls.new files: files
    end
  end
end
