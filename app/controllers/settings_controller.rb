class SettingsController < ApplicationController
  def edit
    # You need to implement a method to fetch the current weekly allowance values.
    # For simplicity, we use a constant hash in this example, but you should fetch the values from a database or a configuration file.
    @weekly_allowance = {
      spending: AllowanceSetting.find_by(category: 'spending')&.amount || 0,
      savings: AllowanceSetting.find_by(category: 'savings')&.amount || 0,
      giving: AllowanceSetting.find_by(category: 'giving')&.amount || 0
    }
  end

  def update
    # Extract the updated allowance values from the form parameters
    updated_allowance = {
      spending: params[:spending].to_f,
      savings: params[:savings].to_f,
      giving: params[:giving].to_f
    }

    # Save the updated allowance settings to your data storage
    # You should replace this with the appropriate method for your application
    save_updated_allowance(updated_allowance)

    # Create AllowanceEvents to log the change
    updated_allowance.each do |category, amount|
      AllowanceEvent.create!(
        event_type: "update_#{category}",
        amount: amount,
        timestamp: Time.current
      )
    end

    # Redirect back to the dashboard
    redirect_to root_path, notice: 'Weekly allowance settings have been updated.'
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
end
