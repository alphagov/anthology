require 'csv'

class RootController < ApplicationController

  def start
    @books = Book.limit(8)
    @recently_added_copies = Copy.recently_added.limit(3)
    @recent_loans = Loan.recently_loaned.includes([:book, :copy]).limit(5)

    # start.html.erb
  end

  CSV_HEADINGS = %w(id title author isbn number_of_copies on_loan_copies).freeze
  def library_csv
    data = CSV.generate do |csv|
      csv << CSV_HEADINGS
      Book.all.each do |b|
        book = []
        book = [
          b['id'],
          b['title'],
          b['author'],
          b['isbn'],
          b.copies.count,
          number_of_copies_on_loan(b)
        ]
        csv << book
      end
    end
    send_data data, filename: "library.csv"
  end

private
  def number_of_copies_on_loan(b)
    loan_count = 0
    b.copies.each do |c|
      loan_count += 1 if c.on_loan?
    end

    "#{loan_count}/#{b.copies.count}"
  end

end
