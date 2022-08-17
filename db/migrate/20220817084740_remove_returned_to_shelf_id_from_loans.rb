class RemoveReturnedToShelfIdFromLoans < ActiveRecord::Migration[7.0]
  def change
    remove_column :loans, :returned_to_shelf_id, :integer
  end
end
