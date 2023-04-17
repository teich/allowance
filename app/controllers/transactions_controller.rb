class TransactionsController < ApplicationController
  before_action :authenticate_user!

  def index
    @allowance_events = AllowanceEvent.where.not(event_type: ['update_spending', 'update_savings', 'update_giving'])
    .order(timestamp: :desc)

    @new_allowance_event = AllowanceEvent.new
  end

  def create
    @allowance_event = AllowanceEvent.new(allowance_event_params)
    @allowance_event.timestamp = Time.current
    if @allowance_event.save
      redirect_to transactions_path, notice: 'Transaction created successfully.'
    else
      @allowance_events = AllowanceEvent.order(timestamp: :desc)
      render :index
    end
  end

  def destroy
    @allowance_event = AllowanceEvent.find(params[:id])
    @allowance_event.destroy
    redirect_to transactions_path, notice: 'Transaction deleted successfully.'
  end

  def edit
    @allowance_event = AllowanceEvent.find(params[:id])
  end

  def update
    @allowance_event = AllowanceEvent.find(params[:id])
    if @allowance_event.update(allowance_event_params)
      redirect_to transactions_path, notice: 'Transaction updated successfully.'
    else
      render :edit
    end
  end

  private

  def allowance_event_params
    params.require(:allowance_event).permit(:event_type, :amount, :description, :timestamp)
  end
end
