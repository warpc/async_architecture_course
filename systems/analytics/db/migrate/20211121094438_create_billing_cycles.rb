class CreateBillingCycles < ActiveRecord::Migration[6.1]
  def change
    enable_extension 'pgcrypto'

    create_table :billing_cycles do |t|
      t.uuid :public_id, null: false
      t.date :date, null: false
      t.decimal :company_profit_amount, default: 0, null: false

      t.timestamps
      t.index :public_id, unique: true
    end
  end
end