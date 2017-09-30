require 'openssl'
require 'securerandom'

module Crypto
  module_function

  def hash(data)
    hasher.hexdigest(data)
  end

  def new_key(size = 2048)
    OpenSSL::PKey::RSA.new(size)
  end

  def sign(data, private_key)
    private_key.sign(hasher, data)
  end

  def verify(data, signature, public_key)
    public_key.verify(hasher, signature, data)
  end

  def random_string(size = 256)
    SecureRandom.hex((size / 2).to_i)
  end

  def random_number
    SecureRandom.random_number
  end

  def hasher
    OpenSSL::Digest::SHA256.new
  end
end
