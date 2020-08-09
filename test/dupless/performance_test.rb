require 'dupless/set/base'
require 'dupless/set/factory'
require 'dupless/file'
require 'dupless/entry'
require 'dupless/mockfiles'
require 'dupless/tc'

module Dupless
  class PerformanceTest < TestCase
    def self.create_mock_file size, bytes, checksum
      name = "#{size}-#{bytes}-#{checksum}"
      MockFile.new name, size, bytes, checksum
    end

    def self.files
      @@files ||= begin
                    ary = Array.new
                    (0 .. 5).each do |size|
                      ('a' .. 'c').each do |bytes|
                        (7 .. 9).each do |checksum|
                          ary << create_mock_file(size, bytes, checksum)
                        end
                      end
                    end

                    ary << create_mock_file(2, 'a', 7)
                    ary << create_mock_file(2, 'a', 7)
                    
                    ary
                  end
    end

    def self.set range
      Set.new files[range]
    end

    def self.entry(*indices)
      Entry.new(indices.collect { |idx| files[idx] })
    end

    def self.performance_build_params
      files.each_with_index do |val, idx|
        info "idx: #{idx}"
        info "val: #{val}"
      end
      info "files.size: #{files.size}"
      sf = Set::Factory.new
      set = sf.set files: files, type: :sorted_by_size
      Array.new.tap do |ary|
        ary << [ [ entry(18, -2, -1) ], set ]
      end
    end

    param_test performance_build_params.each do |exp, set|
      dups = set.run
      info "dups: #{dups}"
      assert_equal exp, dups
    end
  end
end
