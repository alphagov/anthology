# frozen_string_literal: true

class ChangeBookReferenceToInteger < ActiveRecord::Migration[5.2]
  def up
    connection.execute('
      alter table copies
      alter column book_reference
      type integer using cast(book_reference as integer)
    ')
  end

  def down
    change_column :copies, :book_reference, :string
  end
end
