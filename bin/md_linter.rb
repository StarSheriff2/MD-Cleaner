#!/usr/bin/env ruby

require_relative '../lib/linter_logic'
require_relative '../lib/error_checkers'

# Select the file you want to test here. By default the file is lib/test.md.
# Copy or move your markdown file into the lib/ sub-directory of this program's root directory

file = 'lib/test.md'
line_count = 0
checkers = [Heading.new, ParagraphIndent.new, ItalicMiddle.new]

File.open(file, 'r+') do |f|
  while (line = f.gets)
    line_count += 1
    check = Check.new(line, line_count, checkers)
    check.start(check.checkers) { |error_message| puts error_message }
  end
end
