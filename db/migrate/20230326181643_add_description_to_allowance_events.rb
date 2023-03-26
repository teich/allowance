class AddDescriptionToAllowanceEvents < ActiveRecord::Migration[7.0]
  def change
    add_column :allowance_events, :description, :string
  end
end
