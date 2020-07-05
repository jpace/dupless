require 'dupless/element'
require 'dupless/tc'

module Dupless
  class ElementTest < TestCase
    def test_that_it_has_a_version_number
      refute_nil ::Dupless::VERSION
    end

    def test_it_does_something_useful
      assert true
    end
  end
end
