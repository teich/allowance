class AddGeneratedAllowanceToAllowanceEvents < ActiveRecord::Migration[7.0]
  def change
    add_column :allowance_events, :generated_allowance, :boolean, default: false, null: false
  end
end
