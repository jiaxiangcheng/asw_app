class ReplyParentPolymorphy < ActiveRecord::Migration[5.1]
  def change
    change_table :comments do |t|
      t.remove :parent_id, index: true, foreign_key: { to_table: :comments }
      t.references :parent, polymorphic: true, index: true
    end
  end
end
