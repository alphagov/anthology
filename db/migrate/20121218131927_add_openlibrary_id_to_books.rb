class AddOpenlibraryIdToBooks < ActiveRecord::Migration
  def change
    add_column :books, :openlibrary_id, :string
  end
end
