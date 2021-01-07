def get_string
  File.open('lib/test.md', 'r+') do |file|
    str = ''
    while line = file.gets
      str.concat(line)
    end
    str
  end
end
