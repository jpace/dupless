require 'dupless/mockfile'

module Dupless
  class MockFiles
    def self.mockfile size, bytes, checksum
      fname = [ size, bytes, checksum ].join "-"
      MockFile.new fname, size, bytes, checksum
    end

    def self.files
      @@files ||= begin
                    Array.new.tap do |a|
                      a << mockfile(1, "x", 7)
                      a << mockfile(2, "x", 7)
                      a << mockfile(1, "y", 7)
                      a << mockfile(1, "x", 8)
                      a << mockfile(1, "x", 7)
                      a << mockfile(2, "x", 7)
                      a << mockfile(1, "x", 7)
                    end
                  end
    end
  end
end
