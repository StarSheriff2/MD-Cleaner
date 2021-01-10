require_relative '../lib/linter_logic'
require_relative '../lib/error_checkers'

describe Check do
  describe '#initialize' do
    let(:checkers) { double('checkers') }
    subject(:create_string_scanner) { described_class.new('this is a string', 1, checkers) }

    it 'creates a new StringScanner object' do
      string_scanner = create_string_scanner.buffer
      expect(string_scanner).to be_instance_of(StringScanner)
    end
  end

  describe '#start' do
    checkers = [Heading.new, ParagraphIndent.new, ItalicMiddle.new]
    subject(:check_scans) { described_class.new('dummy text', 1, checkers) }

    context 'when all checkers detect an error on the same line' do
      before do
        allow(check_scans).to receive(:match_check).and_return(true, true, true)
      end

      it 'sends scan_until once for each case' do
        expect(check_scans.buffer).to receive(:scan_until).exactly(3).times
        check_scans.start(checkers)
      end

      it 'adds 3 items to @messages array' do
        check_scans.start(checkers)
        messages_length = check_scans.messages.length
        expect(messages_length).to eq(3)
      end

      it 'sends reset 3 times' do
        buffer = check_scans.buffer
        expect(buffer).to receive(:reset).exactly(3).times
        check_scans.start(checkers)
      end
    end

    context 'when two checkers detect an error on the same line' do
      before do
        allow(check_scans).to receive(:match_check).and_return(false, true, true)
      end

      it 'sends scan_until twice' do
        expect(check_scans.buffer).to receive(:scan_until).exactly(2).times
        check_scans.start(checkers)
      end

      it 'adds 2 items to @messages array' do
        check_scans.start(checkers)
        messages_length = check_scans.messages.length
        expect(messages_length).to eq(2)
      end

      it 'sends reset 2 times' do
        buffer = check_scans.buffer
        expect(buffer).to receive(:reset).exactly(2).times
        check_scans.start(checkers)
      end
    end

    context 'when one checker detects an error on the same line' do
      before do
        allow(check_scans).to receive(:match_check).and_return(false, false, true)
      end

      it 'sends scan_until once' do
        expect(check_scans.buffer).to receive(:scan_until).once
        check_scans.start(checkers)
      end

      it 'adds 1 item to @messages array' do
        check_scans.start(checkers)
        messages_length = check_scans.messages.length
        expect(messages_length).to eq(1)
      end

      it 'sends reset once' do
        buffer = check_scans.buffer
        expect(buffer).to receive(:reset).once
        check_scans.start(checkers)
      end
    end
  end

  describe '#match_check' do
    let(:checkers) { double('checkers') }

    context 'when there are errors in the analyzed code' do
      subject(:check_pattern) { described_class.new(' #this text has_some_errors', 1, checkers) }

      context 'when there is a match for Heading\'s pattern: /#[^#+\s]/' do
        it 'returns a truthy value' do
          pattern = /#[^#+\s]/
          result = check_pattern.match_check(pattern)
          expect(result).to be_truthy
        end
      end

      context 'when there is a match for ParagraphIndent\'s pattern: /^\s+\S+/' do
        it 'returns a truthy value' do
          pattern = /^\s+\S+/
          result = check_pattern.match_check(pattern)
          expect(result).to be_truthy
        end
      end

      context 'when there is a match for ItalicMiddle\'s pattern: /\w+_\w+_\w+/' do
        it 'returns a truthy value' do
          pattern = /\w+_\w+_\w+/
          result = check_pattern.match_check(pattern)
          expect(result).to be_truthy
        end
      end
    end

    context 'when there is no match for a given pattern' do
      subject(:check_pattern) { described_class.new('this text has no errors', 1, checkers) }

      it 'returns nil for /#[^#+\s]/' do
        pattern = /#[^#+\s]/
        result = check_pattern.match_check(pattern)
        expect(result).to_not be_truthy
      end

      it 'returns nil for /^\s+\S+/' do
        pattern = /^\s+\S+/
        result = check_pattern.match_check(pattern)
        expect(result).to_not be_truthy
      end

      it 'returns nil for /\w+_\w+_\w+/' do
        pattern = /\w+_\w+_\w+/
        result = check_pattern.match_check(pattern)
        expect(result).to_not be_truthy
      end
    end
  end

  describe '#error_message' do
    let(:checkers) { double('checkers') }
    subject(:check_message) { described_class.new(' this text has an error', 3, checkers) }

    it 'returns a message indicating line number, position, and error message' do
      expected_message = "Warning in Line 3, Position 5: ' this'. "\
      '=> Unless the paragraph is in a list, don’t indent paragraphs with spaces or tabs.'
      msg = '=> Unless the paragraph is in a list, don’t indent paragraphs with spaces or tabs.'
      check_message.buffer.scan_until(/^\s+\S+/)
      result = check_message.error_message(msg)
      expect(result).to eq(expected_message)
    end
  end
end
