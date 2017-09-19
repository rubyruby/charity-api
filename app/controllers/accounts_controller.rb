class AccountsController < ApplicationController
  before_action :authenticate_user, except: [:index, :current, :create]

  def index
    accounts = Blockchain.new.accounts

    render json: { success: true, accounts: accounts.map { |a| AccountSerializer.new(a) } }
  end

  def current
    if current_user
      address = current_user.blockchain_address
      blockchain = Blockchain.new
      balance = blockchain.balance(address)
      is_member = blockchain.member?(address)
    end

    render json: {
      success: true,
      address: address,
      balance: balance,
      isMember: is_member
    }
  end

  def create
    if current_user.nil?
      user = User.create

      render json: { success: true, token: user.token }
    end
  end

  def become_member
    begin
      tx_hash = Blockchain.new.add_member(current_user.blockchain_address, current_user.blockchain_key)
    rescue Exception => e
      error_message = e.message

      puts e.message
      puts e.backtrace
    end

    if tx_hash
      render json: { success: true, txHash: tx_hash }
    else
      render json: { success: false, error: error_message }
    end
  end
end
