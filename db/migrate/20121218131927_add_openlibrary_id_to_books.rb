# frozen_string_literal: true

class AddOpenlibraryIdToBooks < ActiveRecord::Migration[5.2]
  def change
    add_column :books, :openlibrary_id, :string
  end
end
