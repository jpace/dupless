require 'dupless/dirs/match/matcher'
require 'dupless/dir/directory'
require 'dupless/tc'

module Dupless
  module Dirs
    class PerformanceTest < TestCase
      def self.files
        @@files ||= begin
                      Array.new.tap do |a|
                        1.step(10) do |size|
                          ('a' .. 'e').each do |bytes|
                            10.times do |checksum|
                              a << file(size, bytes, checksum)
                            end
                          end
                        end
                      end
                    end
      end

      def self.file size, bytes, checksum
        mockfile size, bytes, checksum
      end

      def self.dir size, offsetpct, lenpct, name = "dir"
        offset = (size * offsetpct).to_i
        length = (size * lenpct).to_i
        Directory.new name + "[#{offset}, #{length}]", files[offset, length].shuffle
      end

      def self.build_match_identical_params
        puts "files: #{files.size}"

        offset_size = Array.new.tap do |a|
          a << [ 0, 1 ]
          a << [ 0, 1 ]
          
          0.0.step(1.0, 0.2) do |offpct|
            a << [ offpct, 1 ]
            0.2.step(1.0, 0.2) do |lenpct|
              a << [ offpct, lenpct ]
            end
          end
        end

        size = 10
        dirs = Array.new.tap do |a|
          [ 10, 25, 50, 100 ].each do |size|
            offset_size.each do |offpct, lenpct|
              a << dir(size, offpct, lenpct)
            end
          end
        end

        dirs.permutation(2).tap do |n|
          puts "n.size: #{n.size}"
        end
      end

      def run_test params, matcher, ntimes, x, y
        strcls = matcher.strategy.class.to_s.sub(%r{.*::(\w+?)[A-Z].*}) { $1 }
        printf "%8d | ", x.children.size
        printf "%8d | ", y.children.size
        
        start = Time.new
        result = nil
        ntimes.times do |n|
          result = matcher.match x, y
        end
        done = Time.new
        # printf "%8s | ", !!result
        
        duration = done - start
        printf "%8.4f | ", duration
        printf "%8.4f | ", duration * 1000 / ntimes
        { x: x, y: y, result: result, ntimes: ntimes, duration: duration }
      end

      def xtest_all
        params = self.class.build_match_identical_params

        strategy = if false
                     
                   else
                     MatchStrategy.new
                   end

        # searching for only identical
        args = { identical: true, contains: false, mismatch: false }
        matcher1 = Matcher.new args.merge({ strategy: IdenticalMatchStrategy.new })
        matcher2 = Matcher.new args.merge({ strategy: MatchStrategy.new })

        tests = Array.new
        iter = 0
        niterations = params.size
        ntimes = 20
        
        params.each do |x, y|
          printf "%8d | %8d | ", iter, niterations

          iter += 1
          # puts "x        : #{x}"
          # puts "y        : #{y}"

          test1 = run_test params, matcher1, ntimes, x, y
          test2 = run_test params, matcher2, ntimes, x, y
          compare_tests test1, test2
          tests << [ test1, test2 ]

          # break if iter > 10
        end
        total1, total2 = tests.inject([ 0, 0 ]) do |s, n|
          s[0] += n.first[:duration]
          s[1] += n.last[:duration]
          s
        end
        if false
          puts
          println "identical match strategy"
          println "total", total1
          println "average", 1000 * total1.to_f / (niterations * ntimes)
          println "default match strategy"
          println "total", total2
          println "average", 1000 * total2 / (niterations * ntimes)
          println "comparison"
          println "diff", total2 - total1
          println "diff%", 100 * (1.0 - total1 / total2)
        end
      end

      def compare_tests test1, test2
        duration1 = test1[:duration]
        # printf "%8.4f | ", duration1
        # println "duration1", duration1
        duration2 = test2[:duration]
        # printf "%8.4f | ", duration2
        # println "duration2", duration2
        printf "%8.4f | ", duration1 - duration2
        printf "%8.4f%% | ", 100 * (1.0 - duration1 / duration2)
        puts
      end

      def println msg, obj = :none
        if obj == :none
          puts msg
        elsif obj.class == Float
          printf "%-15s: %.4f\n", msg, obj
        else
          printf "%-15s: %s\n", msg, obj
        end
      end
    end
  end
end
