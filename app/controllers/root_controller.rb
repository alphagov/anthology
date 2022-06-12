require "csv"

class RootController < ApplicationController
  def start
    @recently_added_copies = Copy.recently_added.limit(3)
    @recent_loans = Loan.recently_loaned.includes(%i[book copy]).limit(5)
  end

  CSV_HEADINGS = %w[id title author isbn number_of_copies on_loan_copies].freeze
  def library_csv
    data = CSV.generate do |csv|
      csv << CSV_HEADINGS
      Book.all.each do |b|
        book = [
          b["id"],
          b["title"],
          b["author"],
          b["isbn"],
          b.copies.count,
          number_of_copies_on_loan(b),
        ]
        csv << book
      end
    end
    send_data data, filename: "library.csv"
  end

private

  def number_of_copies_on_loan(book)
    loan_count = 0
    book.copies.each do |copy|
      loan_count += 1 if copy.on_loan?
    end

    "#{loan_count}/#{book.copies.count}"
  end
end
