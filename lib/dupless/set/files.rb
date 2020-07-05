# -*- ruby -*-

require 'dupless/set/base'
require 'logue'

module Dupless::Set
  class WithFiles < Base
    attr_reader :files
    
    def initialize files: nil
      @files = files || Array.new
    end

    def << obj
      @files << obj
    end

    def to_s
      "files.size: #{@files.size}"
    end
  end
end
