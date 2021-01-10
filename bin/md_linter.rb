#!/usr/bin/env ruby

require_relative '../lib/linter_logic'
require_relative '../lib/error_checkers'

# Select the file you want to test here. By default the file is lib/test.md.
# Copy or move your markdown file into the lib/ sub-directory of this program's root directory

file = 'lib/test.md'
line_count = 0

def run_linter(check, checkers)
  i = 0
  while i < checkers.length do
    if check.match_check(checkers[i].pattern)
      check.buffer.scan_until(checkers[i].pattern)
      puts check.error_message(checkers[i].message)
      check.buffer.reset
    end
    i += 1
  end
end

File.open(file, 'r+') do |f|
  while (line = f.gets)
    line_count += 1
    check = Check.new(line, line_count)
    run_linter(check, check.checkers)
  end
end
