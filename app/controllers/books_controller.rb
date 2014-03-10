class BooksController < ApplicationController
  include BooksHelper

  before_filter :lookup_book, :only => [:show, :edit, :history, :update]

  has_scope :title_search, :as => :q
  has_scope :available do |controller, scope, value|
    case value
    when "true" then scope.available
    when "false" then scope.on_loan
    else
      scope
    end
  end

  def index
    @books = apply_scopes(Book).includes(:copies).all
  end

  def new
    @book = Book.new
  end

  def lookup_isbn
    isbn = params[:isbn].strip.gsub(/\-/, "")
    not_found if isbn.blank?

    metadata = BookMetadataLookup.find_by_isbn(isbn.to_s)
    existing_book = Book.where(:isbn => isbn.gsub(/\-?\s?/,'')).first
    isbn_exists = existing_book.present?

    render :json => metadata.merge({
      :exists => isbn_exists,
      :creatable => ! isbn_exists,
      :existing_book => existing_book,
      :covers => cover_urls(metadata)
    })
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
    # show.html.erb
  end

  def edit
    # edit.html.erb
  end

  def history
    # history.html.erb
  end

  def update
    if @book.update_attributes(params[:book])
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
end
