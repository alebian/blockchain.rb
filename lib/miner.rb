require_relative 'block'
require_relative 'blockchain'

class Miner
  def self.mine_block(last_block, data)
    Block.new(
      index: last_block.index + 1,
      timestamp: Blockchain.current_timestamp,
      data: data,
      previous_hash: last_block.hash
    )
  end
end
