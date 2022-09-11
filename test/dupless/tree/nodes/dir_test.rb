require 'dupless/tree/nodes/dir'
require 'dupless/tc'
require 'dupless/io/println'

module Dupless::TreeNodes  
  class BaseDirTest < Dupless::TestCase
    def setup
      @node = BaseDir.new "/tmp"
    end

    def test_directory?
      assert @node.directory?
    end      

    def test_basename
      assert_equal "tmp", @node.basename.to_s
    end      
  end  

  class EmptyDirTest < Dupless::TestCase
    def setup
      @node = EmptyDir.new "/unlikely"
    end

    def test_directory?
      assert @node.directory?
    end      

    def test_basename
      assert_equal "unlikely", @node.basename.to_s
    end      

    def test_height
      assert_equal 0, @node.height
    end      

    def test_empty?
      assert @node.empty?
    end
  end

  class ParentDirTest < Dupless::TestCase
    def setup
      @node = ParentDir.new Pathname.new(__FILE__).parent
    end

    def test_directory?
      assert @node.directory?
    end      

    def test_basename
      assert_equal "nodes", @node.basename.to_s
    end      

    def test_height
      assert_equal 1, @node.height
    end      

    def test_empty?
      refute @node.empty?
    end
  end
end
