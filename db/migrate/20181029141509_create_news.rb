class CreateNews < ActiveRecord::Migration[5.1]
  def change
    create_table :news do |t|
      t.string :title
      t.string :site
      t.text :body
      t.integer :points
      t.string :author
      t.integer :num_comments
      t.boolean :is_voted

      t.timestamps
    end
  end
end
