require 'singleton'
require_relative 'block'

class Blockchain
  include Singleton

  attr_reader :database

  def initialize
    @database = [create_genesis_block]
  end

  def last_block
    database.last
  end

  def add_block(block)
    @database << block if block.valid? && block.previous_hash == last_block.hash
  end

  def self.current_timestamp
    Time.now.strftime("%Y-%m-%d %H:%M:%S.%6N")
  end

  private

  def create_genesis_block
    Block.new(
      index: 0,
      timestamp: Blockchain.current_timestamp,
      data: "Genesis block",
      previous_hash: "0"
    )
  end
end
