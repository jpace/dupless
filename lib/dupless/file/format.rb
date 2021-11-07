require 'dupless/file/file'

module Dupless
  module Files
  end
end

module Dupless::Files
  class Formatter
    def write_files files: nil
      files.each_with_index do |file, idx|
        write_file file: file, index: idx
      end
      puts
    end
  end

  class BriefFormatter < Formatter
    def write_file file: nil, index: nil
      printf "%d  \"%s\"\n", index, file
    end
  end

  class LongFormatter < Formatter
    def write_file file: nil
      printf "%d  \"%s\"\n", index, file
    end
  end
end
