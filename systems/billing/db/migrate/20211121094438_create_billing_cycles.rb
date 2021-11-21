class CreateBillingCycles < ActiveRecord::Migration[6.1]
  def change
    enable_extension 'pgcrypto'

    create_table :billing_cycles do |t|
      t.uuid :public_id, default: "gen_random_uuid()", null: false
      t.date :date, null: false, uniq: true
      t.decimal :company_profit_amount, default: 0, null: false

      t.timestamps
      t.index :date, unique: true
      t.index :public_id, unique: true
    end
  end
end
