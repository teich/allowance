class CreateAllowanceEvents < ActiveRecord::Migration[7.0]
  def change
    create_table :allowance_events do |t|
      t.string :event_type
      t.decimal :amount
      t.datetime :timestamp

      t.timestamps
    end
  end
end
