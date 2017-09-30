require_relative 'spec_helper'

describe Scripting do
  describe '#anyone_can_spend' do
    it 'has empty output' do
      expect(described_class.anyone_can_spend_output.size).to eq(0)
    end

    it 'has empty output' do
      expect(described_class.anyone_can_spend_input).to eq([:op_true])
    end

    it 'evaluates correctly' do
      expect(
        described_class.eval(
          described_class.anyone_can_spend_input, described_class.anyone_can_spend_output
        )
      ).to be_truthy
    end
  end

  describe '#pay_to_public_key' do
    let(:data) { 'my super data' }
    let(:key) { Crypto.new_key }

    it 'evaluates correctly' do
      result, stack = described_class.eval(
        described_class.pay_to_public_key_input(key, data),
        described_class.pay_to_public_key_output(key)
      )
      expect(result).to be_truthy
      expect(stack.size).to eq(1)
    end

    context 'when trying to verify with other key' do
      let(:forged_key) { Crypto.new_key }

      it 'fails' do
        result, stack = described_class.eval(
          described_class.pay_to_public_key_input(forged_key, data),
          described_class.pay_to_public_key_output(key)
        )
        expect(result).to be_falsey
        expect(stack.size).to eq(1)
      end
    end
  end

  describe '#pay_to_public_key_hash' do
    let(:data) { 'my super data' }
    let(:key) { Crypto.new_key }

    it 'evaluates correctly' do
      result, stack = described_class.eval(
        described_class.pay_to_public_key_hash_input(key, key.public_key, data),
        described_class.pay_to_public_key_hash_output(key.public_key)
      )
      expect(result).to be_truthy
      expect(stack.size).to eq(1)
    end

    context 'when trying to verify with other key' do
      let(:forged_key) { Crypto.new_key }

      it 'fails' do
        result, stack = described_class.eval(
          described_class.pay_to_public_key_hash_input(forged_key, key.public_key, data),
          described_class.pay_to_public_key_hash_output(key.public_key)
        )
        expect(result).to be_falsey
        expect(stack.size).to eq(1)
      end
    end
  end
end
