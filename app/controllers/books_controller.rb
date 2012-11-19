class BooksController < ApplicationController
  include BooksHelper

  def index
    @books = Book.all
  end

  def new
    @book = Book.new
  end

  def create
    @book = Book.new(params[:book])

    if @book.save
      flash[:notice] = 'Book created'
      redirect_to book_path(@book)
    else
      render :action => :new
    end
  end

  def show
    @book = Book.includes(:copies).find(params[:id])
  end
end
