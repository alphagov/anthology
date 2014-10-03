class AddMissingToCopies < ActiveRecord::Migration
  def change
    add_column :copies, :missing, :boolean, default: false
  end
end
