require 'dupless/set/factory'
require 'dupless/file/entry'
require 'dupless/tc'

module Dupless
  class PerformanceTest < TestCase
    def self.files
      @@files ||= begin
                    Array.new.tap do |a|
                      (0 .. 5).each do |size|
                        ('a' .. 'c').each do |bytes|
                          (7 .. 9).each do |checksum|
                            a << mockfile(size, bytes, checksum)
                          end
                        end
                      end
                      
                      a << mockfile(2, 'a', 7)
                      a << mockfile(2, 'a', 7)
                    end
                  end
    end

    def self.entry(*indices)
      Entry.new(indices.collect { |idx| files[idx] })
    end

    def self.performance_build_params
      if false
        files.each_with_index do |val, idx|
          info "idx: #{idx}"
          info "val: #{val}"
        end
      end
      info "files.size: #{files.size}"
      sf = Set::Factory.new
      set = sf.set files: files, type: :sorted_by_size
      Array.new.tap do |ary|
        ary << [ [ entry(18, -2, -1) ], set ]
      end
    end

    param_test performance_build_params.each do |expected, set|
      result = set.entries
      assert_equal expected, result
    end
  end
end
