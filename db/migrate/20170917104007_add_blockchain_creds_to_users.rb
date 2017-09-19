class AddBlockchainCredsToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :blockchain_address, :string
    add_column :users, :blockchain_key, :string
  end
end
