require 'dupless/tree/nodes'
require 'dupless/tree/tree'
require 'dupless/tc'

module Dupless::TreeNodes
  class TreeResources
    def self.file name
      Dupless::TreeNodes::FileNode.new name
    end
    
    def self.dir name, *children
      if children.nil? || children.empty?        
        EmptyDir.new name
      else
        ParentDir.new name, *children
      end
    end
    
    TREE = [
      A = dir("a", []),
      B = dir("b", []),
      C = dir("c", [file("f1")]),
      D = dir("d", [file("f1")]),
      E = dir("e", [dir("f1")]),
      F = dir("f", [dir("d1", [file("f1")])]),
      G = dir("g", [dir("d1", [file("f1")])]),
      H = dir("h", [dir("d1", [file("f1"), file("f2")])]),
      I = dir("i", [dir("d1", [file("f2"), file("f1")])]),
    ]
  end
  
  class Test < Dupless::TestCase
    def test_one
      x = TreeResources::A
      y = TreeResources::B
      obj = Matcher.new.match x, y
      assert obj
    end

    def test_two
      x = TreeResources::C
      y = TreeResources::D
      obj = Matcher.new.match x, y
      assert obj
    end

    def test_three
      x = TreeResources::C
      y = TreeResources::E
      obj = Matcher.new.match x, y
      refute obj
    end

    def test_four
      x = TreeResources::F
      y = TreeResources::G
      obj = Matcher.new.match x, y
      assert obj
    end

    def test_five
      x = TreeResources::H
      y = TreeResources::I
      obj = Matcher.new.match x, y
      assert obj
    end
  end  
end
