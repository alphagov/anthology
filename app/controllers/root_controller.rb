class RootController < ApplicationController

  def start
    @books = Book.limit(8).all

    # start.html.erb
  end

end
