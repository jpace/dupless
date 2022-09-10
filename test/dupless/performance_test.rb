require 'dupless/set/factory'
require 'dupless/file/filematcher'
require 'dupless/tc'

module Dupless
  class PerformanceTest < TestCase
    def self.mockfile size, bytes, checksum
      MockFile.new size, bytes, checksum
    end
    
    def self.files
      fromsize, tosize = 0, 5
      frombytes, tobytes = 'a', 'c'
      fromsum, tosum = 7, 9
      
      @@files ||= begin
                    Array.new.tap do |a|
                      (fromsize .. tosize).each do |size|
                        (frombytes .. tobytes).each do |bytes|
                          (fromsum .. tosum).each do |checksum|
                            a << mockfile(bytes, size, checksum)
                          end
                        end
                      end
                      
                      a << mockfile('a', 2, 7)
                      a << mockfile('a', 2, 7)
                    end
                  end
    end

    def self.performance_build_params
      if false
        files.each_with_index do |val, idx|
          info "idx: #{idx}"
          info "val: #{val}"
        end
      end
      debug "files.size: #{files.size}"
      sf = Set::Factory.new
      set = sf.set files: files, type: :sorted_by_size, matcher: Dupless::FileMatcher.new
      set.run

      exp1 = [ files[-2], files[-1], mockfile('a', 2, 7) ]
      
      Array.new.tap do |ary|
        ary << [ [ exp1 ], set ]
      end
    end
    
    param_test performance_build_params.each do |expected, set|
      result = set.matcher.duplicates
      assert_equal expected, result
    end
  end
end
