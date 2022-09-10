require 'dupless/mockfile'
require 'dupless/dir/directory'

Logue::Log::level = Logue::Level::DEBUG

module Dupless
  module Resources
    def self.file bytes, size, checksum
      MockFile.new bytes, size, checksum
    end
      
    def self.dir name, *children
      Directory.new name, children
    end

    def self.x name, *children
    end

    STRUCTURE = [
      { "empty1" => [] },
      { "empty2" => [] },
      { "1" => [
          { "X17" => [
            "x.1.7",
            ]
          },
          { "X17-Y17" => [
              "x.1.7",
              "y.1.7",
            ]
          },
          { "X17-X27" => [
              "x.1.7",
              "x.2.7",
            ]
          },
          { "X18" => [
              "x.1.8",
            ]
          },
          { "X27" => [
              "x.2.7",
            ]
          },
          { "Z39" => [
              "z.3.9",
            ]
          }
        ]
      },
      { "2" => [
          { "X17-X27" => [
              "x.1.7",
              "x.2.7",
            ]
          }
        ]
      },
      { "3" => [
          { "X17-X27" => [
              "x.1.7",
              "x.2.7",
            ]
          }
        ]
      },
      { "4" => [
          "x.1.7",
          "x.2.7",
        ]
      },
      { "5" => [
          "1-x-7",
        ]
      },
      { "6" => [
          { "x.1.7" => Array.new },
        ]
      }        
    ]

    def self.build_record record
      if record.kind_of? Hash
        name = record.keys.first
        kids = record[name]
        elements = kids.collect do |kid|
          build_record kid
        end
        dir name, *elements
      else
        value = record
        values =  value.split "."
        bytes, size, checksum = values[0], values[1], values[2]
        file bytes, size, checksum
      end
    end

    def self.build_tree tree
      elements = tree.collect do |record|
        build_record record
      end
      dir "/", *elements
    end

    TREE = build_tree STRUCTURE
    
    def find_by_path(*path)
      element = TREE
      path.each do |x|
        element = if x.kind_of? Integer
                    by_index element, x
                  else
                    by_key element, x
                  end
      end
      element
    end
    
    def by_index element, index
      element.children[index] || raise("index: #{index} not found in (0 ... #{element.children.size})")
    end

    def by_key element, key
      element.children.find { |x| x.pathname.to_s == key } || raise("key: #{key} not found in #{element.children.map(&:pathname)}")      
    end
  end
end
