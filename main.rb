require_relative 'blockchain'
require_relative 'miner'

blockchain = Blockchain.instance

(1..10).each do |index|
  blockchain.add_block(Miner.mine_block(blockchain.last_block, index))
end

puts blockchain.database
