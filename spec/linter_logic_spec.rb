require_relative '../lib/linter_logic'

describe Checker do

  describe '#initialize' do
    subject(:create_string_scanner) { described_class.new('this is a string', 1) }

    it 'creates a new StringScanner object' do
      string_scanner = create_string_scanner.buffer
      expect(string_scanner).to be_instance_of(StringScanner)
    end

  end

end
