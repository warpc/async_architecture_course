class CreateTransactions < ActiveRecord::Migration[6.1]
  enable_extension 'pgcrypto'

  def change
    create_table :transactions do |t|
      t.uuid :public_id, default: "gen_random_uuid()", null: false
      t.references :user, null: false, foreign_key: true
      t.references :task, null: true, foreign_key: true
      t.string :reason, null: false
      t.decimal :amount, null: false, default: 0.0

      t.timestamps
    end
  end
end
