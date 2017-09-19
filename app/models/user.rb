class User < ApplicationRecord
  has_secure_token
  after_create :create_blockchain_account

  private

  def create_blockchain_account
    address, private_key_hex = Blockchain.new_account
    self.update_attributes(blockchain_address: address, blockchain_key: private_key_hex)
  end
end
