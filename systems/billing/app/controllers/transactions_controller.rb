class TransactionsController < ApplicationController
  before_action :check_authentication
  before_action :set_transaction, only: :show

  # GET /transactions or /transactions.json
  def index
    if ['manager', 'admin'].include? current_user.role
      @company_profit_amount = Transaction.company_profit_amount(Date.current)
    else
      @transactions = current_user.transactions.includes(:task).for_day(Date.current).desc
    end
  end

  # GET /transactions/1 or /transactions/1.json
  def show
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transaction
      @transaction = Transaction.find(params[:id])
    end
end
