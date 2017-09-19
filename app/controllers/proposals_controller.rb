class ProposalsController < ApplicationController
  def index
    proposals = if current_user
      address = current_user.blockchain_address if current_user
      Blockchain.new.proposals(address)
    else
      Blockchain.new.proposals
    end

    render json: { success: true, proposals: proposals.map { |p| ProposalSerializer.new(p) } }
  end

  def create
    address = params[:account]
    amount = params[:amount].to_d
    comment = params[:comment]

    begin
      tx_hash = Blockchain.new.new_proposal(address, amount, comment, private_key: current_user.blockchain_key)
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

  def vote
    proposal_index = params[:id].to_i
    value = params[:value]

    begin
      tx_hash = Blockchain.new.vote_for_proposal(proposal_index, value, private_key: current_user.blockchain_key)
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

  def finish
    proposal_index = params[:id].to_i

    begin
      tx_hash = Blockchain.new.finish_proposal(proposal_index, private_key: current_user.blockchain_key)
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
