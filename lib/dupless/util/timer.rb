require 'logue/loggable'

module Dupless
  class Timer
    include Logue::Loggable

    def run &blk
      start = Time.now
      debug "start: #{start}"
      
      ret = blk.call

      done = Time.now
      debug "done: #{done}"

      diff = done - start
      debug "diff: #{diff}"

      ret
    end
  end
end
