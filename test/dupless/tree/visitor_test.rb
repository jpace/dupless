require 'dupless/tree/nodes'
require 'dupless/tree/tree'
require 'dupless/tree/visitor'
require 'dupless/tc'
require 'dupless/io/fdprocessor'
require 'dupless/util/ticker'
require 'dupless/io/println'

module Dupless::TreeNodes
  class FDTest < Dupless::FileDirProcessor
    include Println
    
    def initialize args
      @ticker = Ticker.new 50_000
      super(*args)
      @ticker.write_elapsed
      puts
    end

    def tick
      @ticker.tick
    end

    def write_elapsed
      @ticker.write_elapsed
    end
  end
  
  class Minimal < FDTest
    def process_directory dir
      tick
      super
    end
  end

  class TestVisitor < Dupless::TreeNodes::Visitor
    include Println
    
    def initialize(*args)
      @ticker = Ticker.new 50_000      
      nodes = args.collect do |arg|
        pn = Pathname.new arg
        if pn.file?
          Dupless::TreeNodes::FileNode.new pn
        elsif Dir.empty? arg
          Dupless::TreeNodes::EmptyDir.new pn
        else
          Dupless::TreeNodes::ParentDir.new pn
        end
      end
      super(*nodes)
      @ticker.write_elapsed
      puts
    end
    
    def process_directory dir
      tick
      super
    end

    def tick
      @ticker.tick
    end

    def write_elapsed
      @ticker.write_elapsed
    end
  end
  
  class MinimalTree < TestVisitor
    def initialize args
      super(*args)
    end
  end

  # minimal and saves the directory
  class AddDir < FDTest
    def initialize args
      @dirs = Array.new
      super
    end

    def process_directory dir
      @dirs << dir
      tick
      super
    end
  end

  # creates a Dupless directory for each
  class NewDirectory < FDTest
    def process_directory dir
      tick
      Dupless::Directory.new dir
      super
    end
  end
  
  # checks empty against children field of Directory
  class DirChildrenEmpty < FDTest
    def process_directory dir
      tick
      Dupless::Directory.new dir
      unless ddir.children.empty?
        super
      end
    end
  end

  # checks empty against Directory method
  class DirectoryEmpty < FDTest
    def process_directory dir
      tick
      ddir = Dupless::Directory.new dir
      unless ddir.empty?
        super
      end
    end
  end

  # checks for empty directory by Dir.empty?
  class DirEmpty < FDTest
    def process_directory dir
      tick
      unless Dir.empty? dir
        super
      end
    end
  end

  # creates a directory only if not empty
  class DirEmptyNew < FDTest
    def process_directory dir
      tick
      unless Dir.empty? dir
        Dupless::Directory.new dir
        super
      end
    end
  end

  # creates an empty or parent directory based on Dir.empty?
  class DirForType < FDTest
    def process_directory dir
      tick
      if Dir.empty? dir
        Dupless::EmptyDirectory.new dir
      else
        Dupless::ParentDirectory.new dir
        super
      end
    end
  end

  # saves parent directories to instance field
  class DirForTypeAdd < FDTest
    def initialize args
      @dirs = Array.new
      super
    end
    
    def process_directory dir
      tick
      if Dir.empty? dir
        Dupless::EmptyDirectory.new dir
      else
        pn = Dupless::ParentDirectory.new dir
        @dirs << pn
        super
      end
    end
  end

  # iterates over saved directories
  class DirsIterate < FDTest
    def initialize args
      @dirs = Array.new
      super
      println "@dirs.size", @dirs.size
      @dirs.each do |dir|
        # nothing
      end
    end
    
    def process_directory dir
      tick
      if Dir.empty? dir
        Dupless::EmptyDirectory.new dir
      else
        pn = Dupless::ParentDirectory.new dir
        @dirs << pn
        super
      end
    end
  end

  # iterates over saved directories
  class DirsIterateHeight < FDTest
    def initialize args
      @dirs = Array.new
      super
      println "@dirs.size", @dirs.size
      dirticker = Ticker.new 10_000
      @dirs.each do |dir|
        dirticker.tick
        dir.height
      end
      dirticker.write_elapsed
    end
    
    def process_directory dir
      tick
      if Dir.empty? dir
        Dupless::EmptyDirectory.new dir
      else
        pn = Dupless::ParentDirectory.new dir
        @dirs << pn
        super
      end
    end
  end

  # iterates over nodes (directories)
  class NodesIterateHeight < TestVisitor
    def initialize args
      puts "args: #{args}"
      @dirs = Array.new
      super(*args)
      println "@dirs.size", @dirs.size
      dirticker = Ticker.new 10_000
      @dirs.each do |dir|
        dirticker.tick
        dir.height
      end
      dirticker.write_elapsed
      @dirs.each do |dir|
        if dir.height > 10
          puts "dir: #{dir}; height: #{dir.height}"
        end
      end
    end
    
    def process_directory dir
      @dirs << dir
      super
    end
  end

  # iterates over node children (directories)
  class NodesIterateChildren < TestVisitor
    def initialize args
      @dirs = Array.new
      super(*args)
      println "@dirs.size", @dirs.size
      dirticker = Ticker.new 10_000
      @dirs.each do |dir|
        dirticker.tick
        dir.children
      end
      dirticker.write_elapsed
    end
    
    def process_directory dir
      @dirs << dir
      super
    end
  end

  # iterates over node children (directories)
  class NodesHeightChildren < TestVisitor
    def initialize args
      @dirs = Array.new
      super(*args)
      println "@dirs.size", @dirs.size
      dirticker = Ticker.new 10_000
      @dirs.each do |dir|
        dirticker.tick
        dir.children
        dir.height
      end
      dirticker.write_elapsed
    end
    
    def process_directory dir
      @dirs << dir
      super
    end
  end
  
  class DuptreesApp < Dupless::FileDirProcessor
    def initialize args
      @dirs = Array.new
      @index = 0
      @min_height = 10
      super(*args)
    end

    def process_directory dir
      if @index % 50000 == 0
        puts "procdir: index: #{@index}"
      end
      @index += 1
      
      ddir = Dupless::Directory.new(dir)
      if ddir.children.size > 0
        @dirs << ddir
        super
      end
    end

    def process_duplicates
      puts "processing; dirs.size: #{@dirs.size}"
      index = 0
      filtered = @dirs.select do |x|
        if index % 500 == 0
          puts "procdup: index: #{index}"
        end
        index += 1
        x.height >= @min_height
      end
      puts "processing; filtered.size: #{filtered.size}"
      (0 ... filtered.size - 1).each do |xi|
        x = filtered[xi]
        (xi + 1 ... filtered.size).each do |yi|
          y = filtered[yi]
          if x.count == y.count
            obj = Dupless::Tree::Matcher.new
            result = obj.match x, y
            if result
              println "x", x
              println "y", y
              println "x.height", x.height
              println "result", result
            end
          end          
        end
      end
    end

    def write
    end
    
    def println msg, obj
      printf "%-20.20s: %s\n", msg, obj
    end
  end
  
  class VisitorTest < Dupless::TestCase
    include Println
    
    def initialize name
      println "name", name
      @args = ARGV
      super
    end

    def test_Minimal
      Minimal.new @args
    end

    def test_MinimalTree
      MinimalTree.new @args
    end
    
    def test_NewDirectory
      NewDirectory.new @args
    end

    def test_DirChildrenEmpty
      DirChildrenEmpty.new @args
    end

    def test_DirectoryEmpty
      DirectoryEmpty.new @args
    end

    def test_DirEmpty
      DirEmpty.new @args
    end

    def test_DirEmptyNew
      DirEmptyNew.new @args
    end

    def test_DirForType
      DirForType.new @args
    end

    def test_AddDir
      AddDir.new @args
    end

    def test_DirForTypeAdd
      DirForTypeAdd.new @args
    end

    def test_DirsIterate
      DirsIterate.new @args
    end

    if true
      def test_DirsIterateHeight
        DirsIterateHeight.new @args
      end
    end

    def test_NodesIterateHeight
      NodesIterateHeight.new @args
    end

    def test_NodesIterateChildren
      NodesIterateChildren.new @args
    end

    def test_NodesHeightChildren
      NodesHeightChildren.new @args
    end
  end
end
