class CreateTokens < ActiveRecord::Migration[5.1]
  def change
    remove_column :users, :token, :string

    create_table :tokens do |t|
      t.string :access_token
      t.string :refresh_token
      t.datetime :expires_at
      t.belongs_to :user

      t.timestamps
    end
  end
end
