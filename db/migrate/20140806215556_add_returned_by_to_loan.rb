class AddReturnedByToLoan < ActiveRecord::Migration
  def change
    add_column :loans, :returned_by_id, :integer
  end
end
