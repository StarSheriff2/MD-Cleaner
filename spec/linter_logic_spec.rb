require_relative '../lib/linter_logic'

describe Checker do

  describe '#initialize' do
    subject(:create_string_scanner) { described_class.new('this is a string', 1) }

    it 'creates a new StringScanner object' do
      string_scanner = create_string_scanner.buffer
      expect(string_scanner).to be_instance_of(StringScanner)
    end
  end

  describe '#error_checker' do

    context 'when checker is true' do
      subject(:reset_buffer) { described_class.new('  ##this is a string_qwe_asdas', 1) }

      # before do
      #   checkers = reset_buffer.instance_variable_get(:@checkers)
      #   allow(checkers).to receive(:each).and_return(true, true, true)
      # end

      it 'sends reset once for every checker' do
        expect(reset_buffer.buffer).to receive(:reset).exactly(3).times
        # expect(reset_buffer.instance_variable_get(:@checkers)).to receive(:each)
        reset_buffer.error_checker
      end
    end

  end

end
