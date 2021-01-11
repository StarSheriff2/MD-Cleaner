require 'strscan'
require_relative '../lib/error_checkers'

class Check
  attr_accessor :messages
  attr_reader :checkers, :line_errors

  def initialize
    @checkers = [Heading.new, ParagraphIndent.new, ItalicMiddle.new]
    @line_number = 0
    @line_errors = false
  end

  def start(file)
    while (line = file.gets)
      check_line(create_buffer(line))
    end
  end

  private

  def create_buffer(line)
    @line_number += 1
    StringScanner.new(line)
  end

  def check_line(buffer)
    checkers.each do |c|
      next unless match_check(buffer, c.pattern)

      @line_errors = true
      buffer.scan_until(c.pattern)
      puts error_message(buffer, c.message)
      buffer.reset
    end
  end

  def match_check(buffer, pattern)
    buffer.check_until(pattern)
  end

  def error_message(buffer, msg)
    "Warning in Line #{@line_number}, Position #{buffer.pos}: '#{buffer.matched}'. #{msg}"
  end
end
