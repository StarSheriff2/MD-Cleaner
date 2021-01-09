#!/usr/bin/env ruby

require_relative '../lib/linter_logic'

# Select the file you want to test here. By default the file is lib/test.md.
# Change the value of file to the directory where your md file is

file = 'lib/test.md'

start_linter(file)
