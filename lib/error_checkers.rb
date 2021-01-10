class Heading
  attr_reader :pattern, :error_message

  def initialize
    @pattern = /#[^#+\s]/
    @error_message = "=> Always put a space between the number signs, '#', and the heading name."
  end
end

class Paragraph_indent
  attr_reader :pattern, :error_message

  def initialize
    @pattern = /^\s+\S+/
    @error_message = "=> Unless the paragraph is in a list, don’t indent paragraphs with spaces or tabs."
  end
end

class Italic_middle
  attr_reader :pattern, :error_message

  def initialize
    @pattern = /\w+_\w+_\w+/
    @error_message = "=> Use asterisks to italicize the middle of a word for emphasis."
  end
end

