require 'dupless/app/compare'
require 'dupless/file/filematcher'

module Dupless
  class FileCompare < Compare
    def initialize(*args, type: :singlepass, cachename: nil)
      super(*args, type: type, cachename: cachename, matcher: Dupless::FileMatcher.new)
    end

    def show_duplicates filter: nil, formatter: nil
      dups = @set.matcher.duplicates
      info "#dups: #{dups.size}"
      dups.each_with_index do |dup, idx|
        dup.write formatter: formatter
      end
      puts
    end
  end
end
