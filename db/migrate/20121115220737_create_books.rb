class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :title
      t.string :isbn
      t.string :author
      t.string :google_id
      t.timestamps
    end
  end
end
