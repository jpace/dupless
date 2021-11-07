require 'dupless/file/file'
require 'dupless/io/fdprocessor'
require 'dupless/set/factory'
require 'dupless/file/cache'
require 'logue'

Logue::Log::level = Logue::Level::INFO

module Dupless
  class Compare < FileDirProcessor
    include Logue::Loggable
    
    def initialize(*args, type: :singlepass, cachename: nil, matcher: nil)
      cachename ||= "/tmp/dupless.yaml"
      cache = Cache.instance
      cache.set cachename
      sf = Set::Factory.new
      info "type: #{type}"
      @set = sf.set type: type, matcher: matcher
      super(*args)
      @set.run
      info "writing: #{self}"
      cache.write
    end

    def process_file file 
      df = Dupless::File.new file
      @set << df
    end
  end
end
