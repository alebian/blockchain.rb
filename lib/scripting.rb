require_relative 'crypto'

module Scripting
  module_function

  OPCODES = {
    op_false: Proc.new { |stack| stack.push(false) },
    op_true: Proc.new { |stack| stack.push(true) },
    op_if: Proc.new do |stack|

    end,
    op_else: Proc.new do |stack|

    end,
    op_end_if: Proc.new do |stack|

    end,
    op_verify: Proc.new do |stack|
      top = stack.pop
      raise ArgumentError unless top == true
    end,
    op_return: Proc.new do |stack|

    end,
    op_push_data: Proc.new do |stack|

    end,
    op_hash: Proc.new do |stack|
      data = stack.pop
      stack.push(Crypto.hash(data.to_s))
    end,
    op_checksig: Proc.new do |stack|
      public_key = stack.pop
      signature = stack.pop
      data = stack.pop
      stack.push(Crypto.verify(data, signature, public_key))
    end,
    op_checksig_verify: Proc.new do |stack|
      OPCODES[:op_checksig].call(stack)
      OPCODES[:op_verify].call(stack)
    end,
    op_check_multisig: Proc.new do |stack|

    end,
    op_check_multisig_verify: Proc.new do |stack|
      OPCODES[:op_check_multisig].call(stack)
      OPCODES[:op_verify].call(stack)
    end,
    op_dup: Proc.new do |stack|
      top = stack.pop
      stack.push(top)
      stack.push(top)
    end,
    op_equal: Proc.new do |stack|
      first = stack.pop
      second = stack.pop
      stack.push(first == second)
    end,
    op_equal_verify: Proc.new do |stack|
      OPCODES[:op_equal].call(stack)
      OPCODES[:op_verify].call(stack)
    end
  }.freeze

  def eval(input_script, output_script)
    stack = []
    (input_script + output_script).each do |element|
      action = OPCODES.fetch(element, nil)
      if action
        action.call(stack)
      else
        stack.push(element)
      end
    end
    top = stack.pop
    [(stack.size == 0) && (top == true), stack.push(top)]
  end

  def pay_to_public_key_input(private_key, data)
    [data, Crypto.sign(data, private_key)]
  end

  def pay_to_public_key_output(private_key)
    [private_key.public_key, :op_checksig]
  end

  def pay_to_public_key_hash_input(private_key, public_key, data)
    [data, Crypto.sign(data, private_key), public_key]
  end

  def pay_to_public_key_hash_output(public_key)
    [:op_dup, :op_hash, Crypto.hash(public_key.to_s), :op_equal_verify, :op_checksig]
  end

  def anyone_can_spend_output
    []
  end

  def anyone_can_spend_input
    [:op_true]
  end
end
