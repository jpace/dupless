require 'logue/loggable'

module Dupless
  class Timer
    include Logue::Loggable

    def debug &blk
      run :debug, &blk
    end

    def info &blk
      run :info, &blk
    end

    def run level = :info, &blk
      meth = method(level).super_method
      
      start = Time.now
      meth.call "start: #{start}"
      
      ret = blk.call

      done = Time.now
      meth.call "done: #{done}"

      diff = done - start
      meth.call "diff: #{diff}"

      ret
    end
  end
end
