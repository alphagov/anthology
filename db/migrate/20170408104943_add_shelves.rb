class AddShelves < ActiveRecord::Migration[5.2]
  def change
    create_table :shelves do |t|
      t.string :name
      t.timestamps
    end

    add_column :copies, :shelf_id, :integer, default: nil
    add_column :loans, :returned_to_shelf_id, :integer, default: nil

    execute "insert into shelves (name, created_at, updated_at) select 'Third floor', now(), now()"
    execute "insert into shelves (name, created_at, updated_at) select 'Sixth floor', now(), now()"
  end
end
