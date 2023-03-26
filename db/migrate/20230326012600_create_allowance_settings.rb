class CreateAllowanceSettings < ActiveRecord::Migration[7.0]
  def change
    create_table :allowance_settings do |t|
      t.string :category
      t.decimal :amount

      t.timestamps
    end
  end
end
