# typed: true
class CreateCopies < ActiveRecord::Migration[5.2]
  def up
    create_table :copies do |t|
      t.integer :book_id
      t.integer :book_reference, :null => false
      t.boolean :on_loan, :default => false, :null => false
      t.timestamps
    end

    Book.find_each do |book|
      book.copies.create! unless book.copies.any?
    end
  end

  def down
    drop_table :copies
  end
end
