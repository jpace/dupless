module Dupless
  class FileMatcher
    include Logue::Loggable

    attr_reader :duplicates
    
    def initialize
      @duplicates = Array.new
    end

    def add_duplicate dup, x, y
      unless dup
        dup = Array[x]
        @duplicates << dup
      end
      dup << y
      dup
    end
  end
end
