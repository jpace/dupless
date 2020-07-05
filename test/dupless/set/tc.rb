require 'dupless/entry'
require 'dupless/tc'
require 'dupless/mockfiles'

module Dupless::Set
  class TestCase < Dupless::TestCase
    def self.files
      Dupless::MockFiles.files
    end

    def self.entry(*indices)
      Dupless::Entry.new(indices.collect { |idx| files[idx] })
    end
  end
end
