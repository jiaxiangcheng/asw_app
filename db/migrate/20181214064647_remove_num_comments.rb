class RemoveNumComments < ActiveRecord::Migration[5.1]
  def change
    remove_column :submissions, :num_comments, :integer
  end
end
