require 'strscan'
require_relative '../lib/error_checkers'

class Check
  attr_reader :buffer, :checkers, :messages

  def initialize(str, line_number, checkers)
    @buffer = StringScanner.new(str)
    @line_number = line_number
    @checkers = checkers
    @messages = []
  end

  def start(checkers)
    i = 0
    while i < checkers.length
      if match_check(checkers[i].pattern)
        buffer.scan_until(checkers[i].pattern)
        @messages << error_message(checkers[i].message)
        buffer.reset
      end
      i += 1
    end
  end

  def match_check(pattern)
    buffer.check_until(pattern)
  end

  def error_message(msg)
    "Warning in Line #{@line_number}, Position #{buffer.pos}: '#{buffer.matched}'. #{msg}"
  end
end
