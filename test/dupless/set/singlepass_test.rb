require 'dupless/set/singlepass'
require 'dupless/set/tc'

module Dupless::Set
  class SinglePassTest < TestCase
    def self.set_class
      SinglePass
    end

    param_test dups_build_params.each do |exp, set|
      set.run
      dups = set.matcher.duplicates
      assert_equal exp, dups
    end
  end
end
