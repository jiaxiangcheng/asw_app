class AddParametersToSubmission < ActiveRecord::Migration[5.1]
  def change
    change_table :submissions do |t|
      t.integer :points
      t.string :author
      t.integer :num_comments
    end
  end
end
