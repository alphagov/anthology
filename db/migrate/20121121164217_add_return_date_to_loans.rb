class AddReturnDateToLoans < ActiveRecord::Migration
  def change
    add_column :loans, :return_date, :datetime
  end
end
