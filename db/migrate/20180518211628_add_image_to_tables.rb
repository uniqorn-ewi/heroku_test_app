class AddImageToTables < ActiveRecord::Migration[5.1]
  def change
    add_column :blogs, :image, :text
    add_column :users, :image, :text
  end
end
