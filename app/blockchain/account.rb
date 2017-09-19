class Account
  include ActiveModel::Serialization
  attr_reader :address, :balance

  def initialize(account, balance)
    @address = account
    @balance = balance
  end
end
