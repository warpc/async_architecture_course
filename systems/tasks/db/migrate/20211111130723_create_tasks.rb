class CreateTasks < ActiveRecord::Migration[6.1]
  enable_extension 'pgcrypto'

  def change
    create_table :tasks do |t|
      t.uuid :public_id, default: "gen_random_uuid()", null: false
      t.text :description
      t.boolean :is_completed, default: false, null: false
      t.references :creator, null: false, foreign_key: {to_table: :users}
      t.references :assigned_to, null: false, foreign_key: {to_table: :users}

      t.timestamps
    end
  end
end
