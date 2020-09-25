# -*- ruby -*-

require 'pathname'
require 'digest/md5'
require 'yaml'
require 'singleton'

module Dupless
  class Cache
    include Singleton
    
    def initialize
      @file = Pathname.new ENV["HOME"] + "/.dupless/cache.yaml"
      @changed = false
      read
    end

    def read
      if @file.exist?
        @entries = YAML::load_file @file
      else
        @entries = Hash.new
      end
    end

    def write
      return unless @changed
      dir = @file.parent
      unless dir.exist?
        dir.mkpath
      end
      @file.write @entries.to_yaml
    end

    def checksum file
      name = file.pathname.to_s
      entry = @entries[name]
      unless entry
        dig = file.digest
        # only digest for now -- will later have timestamps, etc.
        entry = { digest: dig }
        @entries[name] = entry
        @changed = true
      end
      entry[:digest]
    end
  end
end
