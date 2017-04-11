class BooksController < ApplicationController
  include BooksHelper

  before_filter :lookup_book, :only => [:show, :edit, :history, :update]

  has_scope :title_search, :as => :q
  has_scope :availability do |controller, scope, value|
    case value
    when "available" then scope.available
    when /^shelf_[0-9]+$/ then scope.shelf(value.split('_')[1])
    when "on_loan" then scope.on_loan
    when "missing" then scope.missing
    else
      scope
    end
  end

  def index
    @books = apply_scopes(Book).includes(:copies)
  end

  def new
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)
    @book.created_by = current_user

    if params[:intent] == 'isbn-lookup'
      begin
        assign_metadata_to_book(@book)
        render action: :new
      rescue BookMetadataLookup::BookNotFound
        flash.now[:alert] = "Couldn't find book with isbn #{@book.isbn}"
        render action: :new
      end

      return
    end

    if @book.save
      flash[:notice] = 'Book created'
      redirect_to book_path(@book)
    else
      render :action => :new
    end
  end

  def show
    # show.html.erb
  end

  def edit
    # edit.html.erb
  end

  def history
    # history.html.erb
  end

  def update
    if @book.update_attributes(book_params)
      flash[:notice] = 'Book updated'
      redirect_to book_path(@book)
    else
      render :action => :edit
    end
  end

private
  def lookup_book
    @book = Book.includes(:copies).find(params[:id]) || not_found
  end

  def book_params
    params.require(:book).permit(:title, :author, :google_id, :openlibrary_id, :isbn)
  end

  def assign_metadata_to_book(book)
    book.isbn.strip!
    book.isbn.gsub!(/\-/, "")

    return unless book.isbn.present?

    metadata = BookMetadataLookup.find_by_isbn(book.isbn.to_s)
    metadata.slice(:title, :author, :google_id, :openlibrary_id).each do |attr, value|
      book.send("#{attr}=", value)
    end
  end
end
