class MakeBookReferenceNullable < ActiveRecord::Migration[7.0]
  def change
    change_column_null :copies, :book_reference, true
  end
end
