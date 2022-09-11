require 'pathname'

module Dupless
  module TreeNodes
  end
end

module Dupless::TreeNodes
  class FileNode < Pathname
    def initialize pn
      super pn
    end
    
    def file?
      true
    end

    def height
      0
    end
  end
end
