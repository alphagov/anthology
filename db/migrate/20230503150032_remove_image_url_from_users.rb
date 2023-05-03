class RemoveImageUrlFromUsers < ActiveRecord::Migration[7.0]
  def change
    remove_column :users, :image_url, :text
  end
end
