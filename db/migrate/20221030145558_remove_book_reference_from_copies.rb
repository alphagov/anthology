class RemoveBookReferenceFromCopies < ActiveRecord::Migration[7.0]
  def change
    remove_column :copies, :book_reference, :integer
  end
end
