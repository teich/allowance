class SettingsController < ApplicationController
  before_action :admin_user!

  def edit
    # You need to implement a method to fetch the current weekly allowance values.
    # For simplicity, we use a constant hash in this example, but you should fetch the values from a database or a configuration file.
    @weekly_allowance = {
      spending: AllowanceSetting.find_by(category: "spending")&.amount || 0,
      savings: AllowanceSetting.find_by(category: "savings")&.amount || 0,
      giving: AllowanceSetting.find_by(category: "giving")&.amount || 0,
    }
  
    t = AllowanceEvent.where(event_type: ['update_spending', 'update_savings', 'update_giving'])
    grouped_records = t.group_by{|record| [record.created_at.to_date, record.event_type]}
    @pivot_table = {}
    grouped_records.each do |(date, type), records|
      @pivot_table[date] ||= {}
      @pivot_table[date][type] = records.first.amount
    end

    @allowance_changes = AllowanceEvent.where(event_type: ['update_spending', 'update_savings', 'update_giving'])
    .order(timestamp: :desc)

    @new_allowance_event = AllowanceEvent.new
  end

  def update
    # Extract the updated allowance values from the form parameters
    updated_allowance = {
      spending: params[:spending].to_f,
      savings: params[:savings].to_f,
      giving: params[:giving].to_f,
    }

    # Save the updated allowance settings to your data storage
    # You should replace this with the appropriate method for your application
    save_updated_allowance(updated_allowance)

    # Create AllowanceEvents to log the change
    updated_allowance.each do |category, amount|
      AllowanceEvent.create!(
        event_type: "update_#{category}",
        amount: amount,
        timestamp: Time.current,
      )
    end

    # Redirect back to the dashboard
    redirect_to root_path, notice: "Weekly allowance settings have been updated."
  end

  def run_weekly_allowance
    last_allowance_event = AllowanceEvent.where(generated_allowance: true).order(timestamp: :desc).first

    weeks_since_last_allowance = if last_allowance_event
      ((Time.now - last_allowance_event.timestamp) / 1.week).floor
    else
      1 # If there is no previous allowance event, run for the current week
    end
    
    weeks_since_last_allowance.times do |i|
      allowance_date = (last_allowance_event&.timestamp || Time.now) + (i + 1).weeks
      create_allowance_events
    end
    redirect_to dashboard_index_path, notice: "Allowance for #{weeks_since_last_allowance} week(s) has been run."

  end

  private

  def save_updated_allowance(updated_allowance)
    updated_allowance.each do |category, amount|
      # Find the existing allowance setting for the category or create a new one if it doesn't exist
      allowance_setting = AllowanceSetting.find_or_initialize_by(category: category.to_s)

      # Update the allowance setting amount and save it to the database
      allowance_setting.amount = amount
      allowance_setting.save!
    end
  end

  def create_allowance_events
    categories = ["spending", "savings", "giving"]
    weekly_allowance = {}

    categories.each do |category|
      weekly_allowance[category.to_sym] = AllowanceSetting.find_by(category: category)&.amount || 0
    end

    weekly_allowance.each do |category, amount|
      AllowanceEvent.create!(
        event_type: category,
        amount: amount,
        timestamp: Time.current,
        generated_allowance: true,
        description: "Weekly - #{category}",
      )
    end
  end
end
