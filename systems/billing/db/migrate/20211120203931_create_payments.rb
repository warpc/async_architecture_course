class CreatePayments < ActiveRecord::Migration[6.1]
  def change
    enable_extension 'pgcrypto'

    create_table :payments do |t|
      t.uuid :public_id, default: "gen_random_uuid()", null: false
      t.references :user, null: false, foreign_key: true
      t.decimal :amount, null: false, default: 0.0
      t.integer :status, default: 0, null: false

      t.timestamps
      t.index :public_id, unique: true
    end
  end
end
