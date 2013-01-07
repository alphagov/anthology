require 'book_metadata_lookup'

class Book < ActiveRecord::Base
  attr_accessible :title, :author, :google_id, :openlibrary_id, :isbn

  has_paper_trail

  cattr_accessor :metadata_lookup

  before_validation :strip_isbn, :if => :isbn_changed?
  before_create :update_metadata
  validates :isbn, :presence => :true, :uniqueness => { :case_sensitive => false }

  after_create :setup_first_copy

  has_many :copies, :dependent => :destroy
  has_many :loans, :through => :copies

  belongs_to :created_by, :class_name => "User"

  scope :title_search, proc {|q| where("title ILIKE ?", "%#{q}%") }

  default_scope order("title ASC")

  def strip_isbn
    self.isbn = self.isbn.gsub(/\-?\s?/,'')
  end

  def update_metadata
    book_details = (Book.metadata_lookup || BookMetadataLookup).find_by_isbn(isbn)

    [:title, :author, :google_id, :openlibrary_id].each do |field|
      self.send("#{field.to_s}=".to_sym, book_details[field]) if book_details and book_details[field]
    end
  rescue BookMetadataLookup::BookNotFound
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
