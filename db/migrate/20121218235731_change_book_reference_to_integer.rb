class ChangeBookReferenceToInteger < ActiveRecord::Migration
  def up
    connection.execute(%q{
      alter table copies
      alter column book_reference
      type integer using cast(book_reference as integer)
    })
  end

  def down
    change_column :copies, :book_reference, :string
  end
end
