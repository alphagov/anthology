require "book_metadata_lookup"

class Book < ApplicationRecord
  has_paper_trail ignore: :updated_at

  before_validation :strip_isbn, if: :isbn_changed?
  validates :isbn, uniqueness: { case_sensitive: false, allow_blank: true }
  validates :title, :author, presence: true

  after_create :setup_first_copy

  has_many :copies, dependent: :destroy
  has_many :loans, through: :copies

  belongs_to :created_by, class_name: "User"

  scope :title_search, (proc { |q| where("title ILIKE ?", "%#{q}%") })
  scope :available, -> { joins(:copies).where(copies: { on_loan: false }) }
  scope :on_loan, -> { joins(:copies).where(copies: { on_loan: true }) }
  scope :missing, -> { joins(:copies).where(copies: { missing: true }) }
  scope :shelf, ->(shelf_id) { joins(:copies).where(copies: { on_loan: false, shelf_id: shelf_id }) }

  default_scope -> { order("title ASC") }

  def strip_isbn
    self.isbn = isbn.gsub(/-?\s?/, "")
  end

  def available?
    copies.available.any?
  end

  def setup_first_copy
    copies.create!
  end
end
