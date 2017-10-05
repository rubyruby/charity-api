class Blockchain
  GAS_PRICE = 200000000000
  GAS_LIMIT = 400000
  ACCOUNTS_LIMIT = 100
  PROPOSALS_LIMIT = 100

  def initialize
    @client = Ethereum::IpcClient.new("#{ENV['HOME']}/.ethereum/testnet/geth.ipc", false)
    @formatter = Ethereum::Formatter.new

    contract_json = JSON.parse(File.read('app/blockchain/contracts/charity.json'))

    contract_address = contract_json['address']
    contract_abi = contract_json['abi']

    @contract_instance = Ethereum::Contract.create(name: "Charity", address: contract_address, abi: contract_abi, client: @client)
    @contract_instance.gas_price = GAS_PRICE
    @contract_instance.gas_limit = GAS_LIMIT
  end

  def self.new_account
    new_key = Eth::Key.new
    return new_key.address.downcase, new_key.private_hex
  end

  def add_member(address, private_key_hex)
    tx = signed_transactions(private_key_hex) do |contract_instance|
      contract_instance.transact.add_member(address)
    end

    tx.id
  end

  def member?(address)
    @contract_instance.call.is_member(address)
  end

  def contract_balance
    balance(@contract_instance.address)
  end

  def balance(address)
    wei_amount = @client.eth_get_balance(address)["result"].to_i(16)
    @formatter.from_wei(wei_amount)
  end

  def accounts
    count = @contract_instance.call.num_members
    to = count
    from = count > ACCOUNTS_LIMIT ? count - ACCOUNTS_LIMIT + 1 : 1

    (from..to).map do |idx|
      account = @contract_instance.call.members(idx)
      address = "0x#{account}"
      Account.new(address, balance(address))
    end
  end

  def proposals(address=nil)
    count = @contract_instance.call.num_proposals
    to = count - 1
    from = count > PROPOSALS_LIMIT ? count - PROPOSALS_LIMIT : 0

    res = (from..to).map do |idx|
      proposal = if address
        @contract_instance.call.get_proposal(address, idx)
      else
        @contract_instance.call.proposals(idx)
      end
      Proposal.new(proposal, idx)
    end

    res.sort_by(&:index).reverse
  end

  def new_proposal(address, amount, description, options={})
    wei_amount = @formatter.to_wei(amount)

    tx = signed_transactions(options[:private_key]) do |contract_instance|
      contract_instance.transact.new_proposal(address, wei_amount, description)
    end

    tx.id
  end

  def vote_for_proposal(proposal_index, value, options={})
    tx = signed_transactions(options[:private_key]) do |contract_instance|
      contract_instance.transact.vote(proposal_index, value)
    end

    tx.id
  end

  def finish_proposal(proposal_index, options={})
    tx = signed_transactions(options[:private_key]) do |contract_instance|
      contract_instance.transact.execute_proposal(proposal_index)
    end

    tx.id
  end

  def transaction_status(tx_hash)
    tx = @client.eth_get_transaction_by_hash(tx_hash)['result']
    tx_receipt = @client.eth_get_transaction_receipt(tx_hash)['result']
    if tx_receipt
      block_number = tx_receipt['blockNumber']

      gas_used = tx_receipt['gasUsed'].to_i(16)
      gas = tx['gas'].to_i(16)

      {
        succeeded: block_number && gas_used < gas,
        failed: block_number && gas_used == gas
      }
    end
  end

  private

  def signed_transactions(private_key_hex)
    key = Eth::Key.new priv: private_key_hex
    @contract_instance.key = key
    res = yield(@contract_instance)
    @contract_instance.key = nil
    res
  end
end
