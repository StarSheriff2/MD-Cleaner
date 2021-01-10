#!/usr/bin/env ruby

require_relative '../lib/linter_logic'
require_relative '../lib/error_checkers'

# Select the file you want to test here. By default the file is lib/test.md.
# Copy or move your markdown file into the lib/ sub-directory of this program's root directory

file = 'lib/test.md'
checkers = [Heading.new, ParagraphIndent.new, ItalicMiddle.new]

File.open(file, 'r+') do |f|
  line_count = 0
  line_errors = false
  while (line = f.gets)
    line_count += 1
    check = Check.new(line, line_count, checkers)
    check.start(check.checkers)
    check.messages.each { |msg| puts msg }
    line_errors = true unless check.messages.empty?
  end
  puts 'No errors were detected in your file' unless line_errors
end
