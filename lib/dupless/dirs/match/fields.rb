require 'dupless/util/obj'

module Dupless
  module Dirs
    class MatchFields
      include Obj
      
      attr_accessor :x_only
      attr_accessor :common
      attr_accessor :y_only
      
      def initialize common: Array.new, x_only: Array.new, y_only: Array.new
        @x_only = x_only
        @common = common
        @y_only = y_only
      end

      def == other
        return false unless other && other.class == self.class
        fields = [ :x_only, :common, :y_only ]
        fields.each do |field|
          if send(field) != other.send(field)
            return false
          end
        end
        true
      end

      def to_s
        to_string self, :x_only, :common, :y_only
      end

      def == other
        compare self, other, :x_only, :common, :y_only
      end
    end
  end
end
