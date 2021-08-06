class ChangeUserImageUrlDataType < ActiveRecord::Migration[6.1]
  def change
    change_column :users, :image_url, :text
  end
end
