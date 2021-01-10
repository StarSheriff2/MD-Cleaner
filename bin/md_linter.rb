#!/usr/bin/env ruby

require_relative '../lib/linter_logic'
require_relative '../lib/error_checkers'

# Select the file you want to test here. By default the file is lib/test.md.
# Change the value of file to the directory where your md file is

file = 'lib/test.md'
line_count = 0

def error_checker(check, checkers)
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
    error_checker(check, check.checkers, )
  end
end
