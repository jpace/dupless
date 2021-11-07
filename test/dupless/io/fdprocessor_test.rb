require 'dupless/io/fdprocessor'
require 'dupless/tc'

module Dupless
  class FileDirProcessorTest < TestCase
    def disabled_test_init
      start = Time.new
      FileDirProcessor.new ENV["HOME"] + "/tmp", sort: false
      done = Time.new
      $stderr.puts "elapsed: #{done - start}"
    end
  end
end
