require 'openssl'

class Block
  attr_reader :index, :timestamp, :data, :previous_hash

  def initialize(index:, timestamp:, data:, previous_hash:)
    @index = index
    @timestamp = timestamp
    @data = data
    @previous_hash = previous_hash
  end

  def hash
    return @hash if @hash
    hasher = OpenSSL::Digest::SHA256.new
    @hash ||= hasher.hexdigest(index.to_s + timestamp.to_s + data.to_s + previous_hash.to_s)
  end

  def valid?
    true
  end

  def to_s
    "<Block\n  index: #{index}\n  timestamp: #{timestamp}\n  hash: #{hash}\n  previous_hash: #{previous_hash}\n>"
  end
end
