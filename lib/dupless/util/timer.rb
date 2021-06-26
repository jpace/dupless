require 'logue/loggable'

module Dupless
  class Timer
    include Logue::Loggable

    def run &blk
      start = Time.now
      info "start: #{start}"
      
      ret = blk.call

      done = Time.now
      info "done: #{done}"

      diff = done - start
      info "diff: #{diff}"

      ret
    end
  end
end
