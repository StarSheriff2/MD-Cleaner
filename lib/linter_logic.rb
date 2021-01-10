require 'strscan'
require_relative '../lib/error_checkers'

class Check
  attr_reader :buffer

  def initialize(str, line_number)
    @buffer = StringScanner.new(str)
    @line_number = line_number
    @checkers = [Heading.new, Paragraph_indent.new, Italic_middle.new]
    error_checker
  end

  def error_checker
    i = 0
    while i < @checkers.length do
      if match_check(@checkers[i].pattern)
        buffer.scan_until(@checkers[i].pattern)
        puts_message(@checkers[i].error_message)
        buffer.reset
      end
      i += 1
    end
  end

  def match_check(pattern)
    buffer.check_until(pattern)
  end

  def puts_message(msg)
    puts "Warning in Line #{@line_number}, position #{buffer.pos}: '#{buffer.matched}'. \
        #{msg}"
  end
end

def start_linter(file)
  line_count = 0

  File.open(file, 'r+') do |f|
    while (line = f.gets)
      line_count += 1
      Check.new(line, line_count)
    end
  end
end
