require 'dupless/file/file'

module Dupless
  module Files
  end
end

module Dupless::Files
  class Formatter
    def write entry: nil
      entry.files.each do |file|
        write_file file: file
      end
    end
  end

  class BriefFormatter < Formatter
    def write_file file: nil
      puts file
    end
  end

  class LongFormatter < Formatter
    def write_file file: nil
      puts "file: #{file}"
    end
  end
end
