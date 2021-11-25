class CreateTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :tasks do |t|
      t.uuid :public_id, null: false
      t.string :title, null: false, default: ""
      t.text :description
      t.decimal :assigned_fee, default: 0.0, null: false
      t.decimal :completed_amount, default: 0.0, null: false
      t.timestamps

      t.index :public_id, unique: true
    end
  end
end
