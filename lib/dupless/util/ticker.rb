require 'dupless/io/println'
require 'time'

class Ticker
  include Println
  
  def initialize count = 100_000
    @started = Time.now
    @index = 0
    @count = count
  end

  def tick
    if @index % @count == 0
      write_elapsed
    end
    @index += 1
  end

  def write_elapsed
    diff = Time.now - @started
    println @index, diff
  end
end
