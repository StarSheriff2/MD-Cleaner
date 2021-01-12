class Heading
  attr_reader :pattern, :message

  def initialize
    @pattern = /#[^#+\s]/
    @message = '=> Always put a space between the number signs, \'#\', and the heading name.'
  end
end

class ParagraphIndent
  attr_reader :pattern, :message

  def initialize
    @pattern = /^\s+\S+/
    @message = '=> Unless the paragraph is in a list, don’t indent paragraphs with spaces or tabs.'
  end
end

class ItalicMiddle
  attr_reader :pattern, :message

  def initialize
    @pattern = /\w+_\w+_\w+/
    @message = '=> Use asterisks to italicize the middle of a word for emphasis.'
  end
end
