require 'dupless/set/two_pass'
require 'dupless/set/sorted_by_size'
require 'dupless/set/singlepass'

module Dupless::Set
  class Factory
    def set files: Array.new, type: :twopass
      cls = case type
            when :twopass
              TwoPass
            when :sorted_by_size
              SortedBySize
            when :singlepass
              SinglePass
            else
              raise "unknown set type: #{type.inspect}"
            end
      cls.new files: files
    end
  end
end
