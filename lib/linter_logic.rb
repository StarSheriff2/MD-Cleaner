require 'strscan'

class Checker
  attr_reader :buffer
  @@line_count = 0

  def initialize(str)
    @buffer = StringScanner.new(str)
    @@line_count += 1
    @checkers = [heading, paragraph_indent, italic_middle]
    error_checker
  end

  def error_checker
    @checkers.each do |checker|
      checker
      @buffer.reset
    end
  end

  def heading
    if buffer.scan_until(/#[^#+\s]/)
      puts "Warning in Line #{@@line_count}, position: #{buffer.pos}: '#{buffer.matched}'. => Always put a space between the number signs, '#', and the heading name."
    end
  end

  def paragraph_indent
    if buffer.scan_until(/^\s+\S+/)
      puts "Warning in Line #{@@line_count}, position: #{buffer.pos}: '#{buffer.matched}'. => Unless the paragraph is in a list, don’t indent paragraphs with spaces or tabs."
    end
  end

  def italic_middle
    if buffer.scan_until(/\w+_\w+_\w+/)
      puts "Warning in Line #{@@line_count}, position: #{buffer.pos}: '#{buffer.matched}'. => Use asterisks to italicize the middle of a word for emphasis."
    end
  end
end

def start_linter(file = 'lib/test.md')
  File.open(file, 'r+') do |file|
    while line = file.gets
      Checker.new(line)
    end
  end
end
