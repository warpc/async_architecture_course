class CreateAuthIdentities < ActiveRecord::Migration[6.1]
  def change
    create_table :auth_identities do |t|
      t.references :user, null: false, foreign_key: true
      t.string :uid
      t.string :provider, null: false
      t.string :login, null: false
      t.string :token

      t.timestamps
    end
  end
end
