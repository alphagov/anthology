class CreateLoans < ActiveRecord::Migration[5.2]
  def change
    create_table :loans do |t|
      t.integer :user_id
      t.integer :copy_id
      t.string :state, :default => "on_loan"
      t.datetime :loan_date

      t.timestamps
    end
  end
end
