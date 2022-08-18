class AddShelves < ActiveRecord::Migration[5.2]
  def change
    create_table :shelves do |t|
      t.string :name
      t.timestamps
    end

    add_column :copies, :shelf_id, :integer, default: nil
    add_column :loans, :returned_to_shelf_id, :integer, default: nil
  end
end
