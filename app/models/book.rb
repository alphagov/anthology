require 'book_details_importer'

class Book < ActiveRecord::Base
  attr_accessible :title, :author, :google_id, :isbn

  before_validation :strip_isbn, :if => :isbn_changed?
  before_save :update_metadata, :if => :isbn_changed?
  validates :isbn, :presence => :true, :uniqueness => { :case_sensitive => false }

  after_create :setup_first_copy

  has_many :copies, :dependent => :destroy
  has_many :loans, :through => :copies

  default_scope order("title ASC")

  def strip_isbn
    self.isbn = self.isbn.gsub(/\-?\s?/,'')
  end

  def update_metadata
    book_details = BookDetailsImporter.find_by_isbn(isbn)

    self.title = book_details[:title]
    self.author = book_details[:author]
    self.google_id = book_details[:google_id]
  rescue BookDetailsImporter::BookNotFound
    nil
  end

  def available?
    self.copies.available.any?
  end

  def setup_first_copy
    copy = self.copies.create
    copy
  end
end
