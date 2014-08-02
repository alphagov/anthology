class RootController < ApplicationController

  def start
    @books = Book.limit(8)
    @recently_added_copies = Copy.recently_added.limit(3)
    @recent_loans = Loan.recently_loaned.includes([:book, :copy]).limit(5)

    # start.html.erb
  end

end
