class AddCreatedByIdToBooks < ActiveRecord::Migration
  def change
    add_column :books, :created_by_id, :integer
  end
end
