require 'dupless/tree/nodes/file'
require 'dupless/tc'
require 'dupless/io/println'

module Dupless::TreeNodes  
  class FileNodeTest < Dupless::TestCase
    def setup
      @node = FileNode.new "/tmp/foo.txt"
    end

    def test_file?
      assert @node.file?
    end

    def test_height
      assert_equal 0, @node.height
    end      
  end
end
