require 'openssl'

class Secret
  attr_accessor :cipher, :message

  def initialize(message = nil)
    @cipher = OpenSSL::Cipher.new 'AES-128-CBC'
    @message = message
  end

  def save(pwd)
    cipher.encrypt
    iv = cipher.random_iv

    salt = OpenSSL::Random.random_bytes 16
    iter = 20000
    key_len = cipher.key_len
    digest = OpenSSL::Digest::SHA256.new
    key = OpenSSL::PKCS5.pbkdf2_hmac(pwd, salt, iter, key_len, digest)
    cipher.key = key

    encrypted = cipher.update message
    encrypted << cipher.final
    File.write('data/encryped_message', encrypted)
    File.write('data/encryped_message_salt', salt)
    File.write('data/encryped_message_iv', iv)
  end

  def load(pwd)
    cipher.decrypt
    cipher.iv = File.read('data/encryped_message_iv')

    salt = File.read('data/encryped_message_salt')
    iter = 20000
    key_len = cipher.key_len
    digest = OpenSSL::Digest::SHA256.new
    key = OpenSSL::PKCS5.pbkdf2_hmac(pwd, salt, iter, key_len, digest)

    cipher.key = key

    decrypted = cipher.update File.read('data/encryped_message')
    decrypted << cipher.final
    @message = decrypted
  end
end
