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
      if @file.exist?
        @entries = YAML::load_file @file
      else
        @entries = Hash.new
      end
    end

    def read
      if @file.exist?
        @entries = YAML::load @file
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
      # puts "name: #{name}"
      entry = @entries[name]
      if entry
        entry[:digest]
      else
        dig = file.digest
        # puts "dig: #{dig}"
        entry = { digest: dig }
        @entries[name] = entry
        @changed = true
        # write
        entry[:digest]
      end
    end
  end
end
