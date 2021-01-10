require 'strscan'
require_relative '../lib/error_checkers'

class Check
  attr_reader :buffer, :checkers

  def initialize(str, line_number)
    @buffer = StringScanner.new(str)
    @line_number = line_number
    @checkers = [Heading.new, Paragraph_indent.new, Italic_middle.new]
  end

  def match_check(pattern)
    buffer.check_until(pattern)
  end

  def error_message(msg)
    "Warning in Line #{@line_number}, position #{buffer.pos}: '#{buffer.matched}'. #{msg}"
  end
end
