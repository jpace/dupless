require 'dupless/tree/nodes'
require 'dupless/io/println'
require 'logue'

module Dupless::TreeNodes
  class Matcher
    include Println
    
    attr_reader :matched

    def no_match
      @matched = false
    end
    
    def match x, y
      if x.count != y.count || x.basenames != y.basenames
        return no_match
      end
      
      x.children.each do |xkid|
        ykid = y.children.detect { |kid| kid.basename == xkid.basename }
        if xkid.class != ykid.class
          return no_match
        elsif xkid.kind_of? Dupless::TreeNodes::BaseDir
          unless match xkid, ykid
            return no_match
          end
        end
        # we're not comparing file by other than their names.
      end
      return @matched = true
    end
  end
end
