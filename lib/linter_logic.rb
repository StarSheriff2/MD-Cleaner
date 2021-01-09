require 'strscan'

class Checker
  attr_reader :buffer

  def initialize(str, line_number)
    @buffer = StringScanner.new(str)
    @line_number = line_number
    @checkers = [heading, paragraph_indent, italic_middle]
    error_checker
  end

  def error_checker
    @checkers.each do |checker|
      puts checker if checker
      @buffer.reset
    end
  end

  def heading
    return unless buffer.scan_until(/#[^#+\s]/)

    "Warning in Line #{@line_number}, position #{buffer.pos}: '#{buffer.matched}'. \
    => Always put a space between the number signs, '#', and the heading name."
  end

  def paragraph_indent
    return unless buffer.scan_until(/^\s+\S+/)

    "Warning in Line #{@line_number}, position #{buffer.pos}: '#{buffer.matched}'. \
    => Unless the paragraph is in a list, don’t indent paragraphs with spaces or tabs."
  end

  def italic_middle
    return unless buffer.scan_until(/\w+_\w+_\w+/)

    "Warning in Line #{@line_number}, position #{buffer.pos}: '#{buffer.matched}'. \
    => Use asterisks to italicize the middle of a word for emphasis."
  end
end

def start_linter(file)
  line_count = 0

  File.open(file, 'r+') do |f|
    while (line = f.gets)
      line_count += 1
      Checker.new(line, line_count)
    end
  end
end
