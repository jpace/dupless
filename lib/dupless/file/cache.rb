require 'pathname'
require 'digest/md5'
require 'yaml'
require 'singleton'
require 'logue/loggable'

module Dupless
  class Cache
    include Singleton
    include Logue::Loggable

    def set fname = ENV["HOME"] + "/.dupless/cache.yaml"
      @file = Pathname.new fname
      info "cache file: #{@file}"
      @changed = false
      @entries = @file.exist? ? YAML::load_file(@file) : Hash.new
    end

    def write
      info "writing ..."
      return unless @changed
      dir = @file.parent
      unless dir.exist?
        dir.mkpath
      end
      @file.write @entries.to_yaml
    end

    def add_entry fname, digest
      puts "#{fname} => #{digest}"
      @changed = true
      
      # only digest for now -- will later have timestamps, etc.
      @entries[fname] = { digest: digest }
    end

    def checksum file
      fname = file.pathname.expand_path.to_s
      entry = @entries[fname] || begin
                                   digest = file.digest
                                   add_entry fname, digest
                                 end
      entry[:digest]
    end
  end
end
