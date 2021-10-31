module Dupless
  module Dirs
    class MatchFields
      attr_reader :x_only
      attr_reader :common
      attr_reader :y_only
      
      def initialize
        @x_only = Array.new
        @common = Array.new
        @y_only = Array.new
      end
    end
  end
end
