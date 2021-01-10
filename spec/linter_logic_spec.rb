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

    context 'when match_check returns true on all cases' do
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

    context 'when match_check returns true twice' do
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

  end

end
