class RenameShelvesToLocations < ActiveRecord::Migration[7.0]
  def change
    rename_table :shelves, :locations
    rename_column :copies, :shelf_id, :location_id
  end
end
