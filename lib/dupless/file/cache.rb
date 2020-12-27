require 'pathname'
require 'digest/md5'
require 'yaml'
require 'singleton'

module Dupless
  class Cache
    include Singleton

    def set fname = ENV["HOME"] + "/.dupless/cache.yaml"
      @file = Pathname.new fname
      puts "file: #{@file}"
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
      puts "writing ..."
      return unless @changed
      dir = @file.parent
      unless dir.exist?
        dir.mkpath
      end
      @file.write @entries.to_yaml
    end

    def checksum file
      name = file.pathname.expand_path.to_s
      entry = @entries[name]
      unless entry
        dig = file.digest
        puts "#{name} => #{dig}"
        # only digest for now -- will later have timestamps, etc.
        entry = { digest: dig }
        @entries[name] = entry
        @changed = true
      end
      entry[:digest]
    end
  end
end
