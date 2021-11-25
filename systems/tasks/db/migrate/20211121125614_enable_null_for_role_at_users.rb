class EnableNullForRoleAtUsers < ActiveRecord::Migration[6.1]
  def change
    change_column_null(:users, :role, true)
  end
end
