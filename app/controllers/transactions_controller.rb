class TransactionsController < ApplicationController
  def status
    status = Blockchain.new.transaction_status(params[:id])

    render json: { success: true, status: status }
  end
end
