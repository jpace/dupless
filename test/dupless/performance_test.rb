require 'dupless/set/factory'
require 'dupless/file/dupfiles'
require 'dupless/file/filematcher'
require 'dupless/tc'

module Dupless
  class PerformanceTest < TestCase
    def self.files
      fromsize, tosize = 0, 5
      frombytes, tobytes = 'a', 'c'
      fromsum, tosum = 7, 9
      
      @@files ||= begin
                    Array.new.tap do |a|
                      (fromsize .. tosize).each do |size|
                        (frombytes .. tobytes).each do |bytes|
                          (fromsum .. tosum).each do |checksum|
                            a << mockfile(size, bytes, checksum)
                          end
                        end
                      end
                      
                      a << mockfile(2, 'a', 7)
                      a << mockfile(2, 'a', 7)
                    end
                  end
    end

    def self.dupfiles(*indices)
      DuplicateFiles.new(indices.collect { |idx| files[idx] })
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
      set = sf.set files: files, type: :sorted_by_size, matcher: Dupless::FileMatcher.new
      set.run
      Array.new.tap do |ary|
        ary << [ [ dupfiles(18, -2, -1) ], set ]
      end
    end

    param_test performance_build_params.each do |expected, set|
      result = set.matcher.duplicates
      assert_equal expected, result
    end
  end
end
