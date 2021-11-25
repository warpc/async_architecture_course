class CreateDailyStatistics < ActiveRecord::Migration[6.1]
  def change
    create_table :daily_statistics do |t|
      t.date :date, null: false
      t.decimal :company_profit_amount, default: 0, null: false
      t.uuid :most_expensive_task_public_id
      t.decimal :most_expensive_task_price, default: 0, null: false
      t.integer :users_with_negative_balance_count, default: 0, null: false

      t.timestamps

      t.index :date, unique: true
    end
  end
end
