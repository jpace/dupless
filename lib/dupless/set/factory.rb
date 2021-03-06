require 'dupless/set/two_pass'
require 'dupless/set/sorted_by_size'
require 'dupless/set/singlepass'

module Dupless::Set
  class Factory
    def set files: Array.new, type: :twopass, matcher: Dupless::FileMatcher.new
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
      puts "matcher.object_id: #{matcher.object_id}"
      cls.new files: files, matcher: matcher
    end
  end
end
