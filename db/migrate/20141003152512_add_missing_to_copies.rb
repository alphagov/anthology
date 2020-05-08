# typed: true
class AddMissingToCopies < ActiveRecord::Migration[5.2]
  def change
    add_column :copies, :missing, :boolean, default: false
  end
end
