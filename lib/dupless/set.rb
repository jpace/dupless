# -*- ruby -*-

require 'dupless/file'
require 'dupless/entry'
require 'logue'

module Dupless
  class Set
    include Logue::Loggable
    
    def duplicates
    end

    def inspect
      to_s
    end
  end
end