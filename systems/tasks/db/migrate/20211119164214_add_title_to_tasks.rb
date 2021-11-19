class AddTitleToTasks < ActiveRecord::Migration[6.1]
  def change
    add_column :tasks, :title, :string, null: false, default: ""
  end
end
