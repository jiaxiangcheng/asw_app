class AddForeignkey < ActiveRecord::Migration[5.1]
  def change
    change_table :submissions do |t|
      t.remove :author
      t.belongs_to :user, index: true
    end
  end
end
