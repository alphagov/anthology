class RootController < ApplicationController

  def start
    @books = Book.limit(8).all
    @recently_added_copies = Copy.recently_added.limit(3).all
    @recent_loans = Loan.recently_loaned.includes([:book, :copy]).limit(5).all

    # start.html.erb
  end

end
