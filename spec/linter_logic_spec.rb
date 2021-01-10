require_relative '../lib/linter_logic'
require_relative '../lib/error_checkers'

describe Check do

  describe '#initialize' do
    subject(:create_string_scanner) { described_class.new('this is a string', 1) }

    it 'creates a new StringScanner object' do
      string_scanner = create_string_scanner.buffer
      expect(string_scanner).to be_instance_of(StringScanner)
    end
  end

  describe '#error_checker' do

    context 'when match_check is true for an error checker' do
      subject(:check_scans) { described_class.new('dummy text', 1) }

      before do
        allow(check_scans).to receive(:match_check).and_return(true, true, true)
        allow(check_scans.buffer).to receive(:scan_until).with(0).exactly(3).times
      end

      it 'sends scan_until once for each case' do
        expect(check_scans.buffer).to receive(:scan_until).with(0).exactly(3).times
        # expect(reset_buffer.instance_variable_get(:@checkers)).to receive(:each)
        check_scans.error_checker
      end
    end

  end

end
