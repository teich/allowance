class DashboardController < ApplicationController
  def index
    @spending_balance = calculate_balance('spending')
    @savings_balance = calculate_balance('savings')
    @giving_balance = calculate_balance('giving')

    @last_allowance_run_date = AllowanceEvent.where(event_type: ['spending', 'savings', 'giving'])
                                             .order(timestamp: :desc)
                                             .limit(1)
                                             .pluck(:timestamp)
                                             .first
  end

  private

  def calculate_balance(category)
    allowance_events = AllowanceEvent.where(event_type: category)
    balance = 0

    allowance_events.each do |event|
      case event.event_type
      when 'spending'
        balance += event.amount
      when 'savings'
        balance += event.amount
      when 'giving'
        balance += event.amount
      end
    end

    balance
  end
end
