class AddObjectChangesToVersions < ActiveRecord::Migration[5.2]
  def change
    add_column :versions, :object_changes, :text
  end
end
