class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.uuid :public_id, null: false
      t.string :full_name
      t.string :role, null: false
      t.string :email

      t.timestamps
    end
  end
end
