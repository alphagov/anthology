class AddReturnDateToLoans < ActiveRecord::Migration[5.2]
  def change
    add_column :loans, :return_date, :datetime
  end
end
