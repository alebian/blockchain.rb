require_relative 'spec_helper'

describe Crypto do
  describe '.hash' do
    let(:expected_hash) { '15e2b0d3c33891ebb0f1ef609ec419420c20e320ce94c65fbc8c3312448eb225' }

    it 'hashes the genesis block correctly' do
      expect(described_class.hash('123456789')).to eq(expected_hash)
    end
  end
end
