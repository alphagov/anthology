class BooksController < ApplicationController
  include BooksHelper

  has_scope :title_search, :as => :q

  def index
    @books = apply_scopes(Book).all

    if params[:display] == :list
      render "list"
    else
      render "grid"
    end
  end

  def new
    @book = Book.new
  end

  def lookup_isbn
    isbn = params[:isbn]
    render_404 if isbn.blank?

    result = BookMetadataLookup.find_by_isbn(isbn.to_s)
    render :json => result.merge(:covers => cover_urls(result))
  rescue BookMetadataLookup::BookNotFound
    render :json => { }
  end

  def create
    @book = Book.new(params[:book])
    @book.created_by = current_user

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
