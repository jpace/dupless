require 'dupless/set/singlepass'
require 'dupless/set/tc'

Logue::Log::level = Logue::Level::INFO

module Dupless::Set
  class SinglePassTest < TestCase
    def self.set_class
      SinglePass
    end

    param_test dups_build_params.each do |expected, set|
      set.run
      result = set.matcher.duplicates
      assert_equal expected, result
    end
  end
end
