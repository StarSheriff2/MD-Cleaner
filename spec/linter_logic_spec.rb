require_relative '../lib/linter_logic'
require_relative '../lib/error_checkers'

describe Check do
  describe '#start' do
    subject(:check_start) { described_class.new }
    let(:file) { instance_double(File) }

    it 'sends each_line' do
      expect(file).to receive(:each_line)
      check_start.start(file)
    end

    context 'when file has 1 line' do
      it 'calls check_line once' do
        expect(check_start).to receive(:check_line).once
        file = StringIO.new("1")
        check_start.start(file)
      end
    end

    context 'when file has 3 lines' do
      it 'calls check_line 3 times' do
        expect(check_start).to receive(:check_line).exactly(3).times
        file = StringIO.new("1\n2\n3")
        check_start.start(file)
      end
    end
  end

  describe '#create_buffer' do
    subject(:check_buffer) { described_class.new }

    it 'creates a new StringScanner with a line of string' do
      expect(StringScanner).to receive(:new).with('this is a string line')
      line = 'this is a string line'
      check_buffer.send(:create_buffer, line)
    end
  end

  describe '#check_line' do
    subject(:line_count) { described_class.new }
    let(:buffer) { instance_double(StringScanner) }

    before do
      allow(line_count).to receive(:match_check).and_return(false)
    end

    it 'adds 1 to @line_number' do
      call_checkline = Proc.new { line_count.send(:check_line, buffer) }
      line_number = Proc.new { line_count.instance_variable_get(:@line_number) }
      expect(&call_checkline).to change(&line_number).by (1)
    end

    context 'when an error is detected in a line' do
      subject(:checks_line) { described_class.new }

      before do
        allow(STDOUT).to receive(:puts)
        allow(buffer).to receive(:scan_until)
        allow(buffer).to receive(:pos)
        allow(buffer).to receive(:matched)
        allow(buffer).to receive(:reset)
      end

      context 'by all 3 checkers' do
        before do
          allow(checks_line).to receive(:match_check).and_return(true, true, true)
        end

        it 'changes @line_errors to true' do
          checks_line.send(:check_line, buffer)
          line_errors = checks_line.line_errors
          expect(line_errors).to be_truthy
        end

        it 'sends scan_until 3 times' do
          expect(buffer).to receive(:scan_until).exactly(3).times
          checks_line.send(:check_line, buffer)
        end

        it 'sends reset 3 times' do
          expect(buffer).to receive(:reset).exactly(3).times
          checks_line.send(:check_line, buffer)
        end
      end

      context 'by two checkers' do
        before do
          allow(checks_line).to receive(:match_check).and_return(false, true, true)
        end

        it 'changes @line_errors to true' do
          checks_line.send(:check_line, buffer)
          line_errors = checks_line.line_errors
          expect(line_errors).to be_truthy
        end

        it 'sends scan_until twice' do
          expect(buffer).to receive(:scan_until).exactly(2).times
          checks_line.send(:check_line, buffer)
        end

        it 'sends reset 3 times' do
          expect(buffer).to receive(:reset).exactly(2).times
          checks_line.send(:check_line, buffer)
        end
      end

      context 'by one checker' do
        before do
          allow(checks_line).to receive(:match_check).and_return(false, false, true)
        end

        it 'changes @line_errors to true' do
          checks_line.send(:check_line, buffer)
          line_errors = checks_line.line_errors
          expect(line_errors).to be_truthy
        end

        it 'sends scan_until twice' do
          expect(buffer).to receive(:scan_until).once
          checks_line.send(:check_line, buffer)
        end

        it 'sends reset 3 times' do
          expect(buffer).to receive(:reset).once
          checks_line.send(:check_line, buffer)
        end
      end
    end
  end

  # describe '#match_check' do
  #   let(:checkers) { double('checkers') }

  #   context 'when there are errors in the analyzed code' do
  #     subject(:check_pattern) { described_class.new(' #this text has_some_errors', 1, checkers) }

  #     context 'when there is a match for Heading\'s pattern: /#[^#+\s]/' do
  #       it 'returns a truthy value' do
  #         pattern = /#[^#+\s]/
  #         result = check_pattern.match_check(pattern)
  #         expect(result).to be_truthy
  #       end
  #     end

  #     context 'when there is a match for ParagraphIndent\'s pattern: /^\s+\S+/' do
  #       it 'returns a truthy value' do
  #         pattern = /^\s+\S+/
  #         result = check_pattern.match_check(pattern)
  #         expect(result).to be_truthy
  #       end
  #     end

  #     context 'when there is a match for ItalicMiddle\'s pattern: /\w+_\w+_\w+/' do
  #       it 'returns a truthy value' do
  #         pattern = /\w+_\w+_\w+/
  #         result = check_pattern.match_check(pattern)
  #         expect(result).to be_truthy
  #       end
  #     end
  #   end

  #   context 'when there is no match for a given pattern' do
  #     subject(:check_pattern) { described_class.new('this text has no errors', 1, checkers) }

  #     it 'returns nil for /#[^#+\s]/' do
  #       pattern = /#[^#+\s]/
  #       result = check_pattern.match_check(pattern)
  #       expect(result).to_not be_truthy
  #     end

  #     it 'returns nil for /^\s+\S+/' do
  #       pattern = /^\s+\S+/
  #       result = check_pattern.match_check(pattern)
  #       expect(result).to_not be_truthy
  #     end

  #     it 'returns nil for /\w+_\w+_\w+/' do
  #       pattern = /\w+_\w+_\w+/
  #       result = check_pattern.match_check(pattern)
  #       expect(result).to_not be_truthy
  #     end
  #   end
  # end

  # describe '#error_message' do
  #   let(:checkers) { double('checkers') }
  #   subject(:check_message) { described_class.new(' this text has an error', 3, checkers) }

  #   it 'returns a message indicating line number, position, and error message' do
  #     expected_message = "Warning in Line 3, Position 5: ' this'. "\
  #     '=> Unless the paragraph is in a list, don’t indent paragraphs with spaces or tabs.'
  #     msg = '=> Unless the paragraph is in a list, don’t indent paragraphs with spaces or tabs.'
  #     check_message.buffer.scan_until(/^\s+\S+/)
  #     result = check_message.error_message(msg)
  #     expect(result).to eq(expected_message)
  #   end
  # end
end
