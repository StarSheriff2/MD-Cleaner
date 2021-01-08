require 'strscan'

class Checker
  attr_reader :buffer
  @@line_count = 0

  def initialize(str)
    @buffer = StringScanner.new(str)
    @@line_count += 1
    scan
  end

  def scan
    until @buffer.eos?
      error_checker
    end
  end

  def error_checker
    heading
    paragraph_indent
    buffer.terminate
  end

  def heading
    if buffer.scan_until(/#[^#+\s]/)
      puts "Warning in Line #{@@line_count}, position: #{buffer.pos}: '#{buffer.matched}'. Always put a space between the number signs '#' and the heading name"
      buffer.terminate
    end
  end

  def paragraph_indent
    if buffer.scan_until(/^\s+\S+/)
      puts "Warning in Line #{@@line_count}, position: #{buffer.pos}: '#{buffer.matched}'. To create paragraphs, use a blank line to separate one or more lines of text."
      buffer.terminate
    end
  end
end

def start_linter
  File.open('lib/test.md', 'r+') do |file|
    while line = file.gets
      Checker.new(line)
    end
  end
end
