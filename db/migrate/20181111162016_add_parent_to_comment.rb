class AddParentToComment < ActiveRecord::Migration[5.1]
  def change
    change_table :comments do |t|
      t.belongs_to :parent, index: true, foreign_key: { to_table: :comments }
    end
  end
end
