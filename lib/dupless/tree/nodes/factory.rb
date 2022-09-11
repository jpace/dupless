require 'dupless/tree/nodes/file'
require 'dupless/tree/nodes/dir'
require 'pathname'

module Dupless
  module TreeNodes
  end
end

module Dupless::TreeNodes  
  class NodeFactory
    def create arg
      pn = arg.kind_of?(Pathname) ? arg : Pathname.new(arg)
      if pn.file?
        FileNode.new pn
      elsif Dir.empty? arg
        EmptyDir.new pn
      else
        ParentDir.new pn
      end
    end
  end
end
