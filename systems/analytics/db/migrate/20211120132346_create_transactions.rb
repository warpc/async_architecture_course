class CreateTransactions < ActiveRecord::Migration[6.1]
  enable_extension 'pgcrypto'

  def change
    create_table :transactions do |t|
      t.uuid :public_id, null: false
      t.uuid :user_public_id
      t.uuid :task_public_id
      t.string :reason
      t.decimal :amount, default: 0.0

      t.timestamps
      t.index :public_id, unique: true
      t.index :user_public_id
      t.index :task_public_id
    end
  end
end
