class TransactionsController < ApplicationController
  def status
    status = Blockchain.new.transaction_status(params[:id])

    if status
      render json: { success: true, status: status }
    else
      render json: { success: false, error: 'Transaction not found' }
    end
  end
end
