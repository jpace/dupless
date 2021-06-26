require 'dupless/file/dupfiles'
require 'dupless/tc'
require 'dupless/mockfiles'

module Dupless::Set
  class TestCase < Dupless::TestCase
    def self.files
      Dupless::MockFiles.files
    end

    def self.dupfiles(*indices)
      Dupless::DuplicateFiles.new(indices.collect { |idx| files[idx] })
    end
  end
end
