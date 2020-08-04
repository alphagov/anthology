class Loan < ApplicationRecord
  belongs_to :copy
  belongs_to :user
  belongs_to :returned_by, class_name: "User"
  belongs_to :returned_to_shelf, class_name: "Shelf"

  has_one :book, through: :copy

  scope :on_loan, -> { where(state: "on_loan") }
  scope :returned, -> { where(state: "returned") }
  scope :history, -> { where(state: "returned").order("loan_date DESC") }
  scope :recently_loaned, -> { order("loan_date DESC") }

  validates :user, presence: true
  validates :copy, presence: true

  before_create :set_loan_date
  after_save :update_copy_loan_status

  class NotOnLoan < RuntimeError; end

  def return(as_user = nil, to_shelf = nil)
    raise NotOnLoan unless state == "on_loan"

    self.state = "returned"
    self.return_date = Time.zone.now
    self.returned_by = as_user
    self.returned_to_shelf = to_shelf
    save!
  end

  def set_loan_date
    self.loan_date ||= Time.zone.now
  end

  def update_copy_loan_status
    copy.update_loan_status!
  end

  def returned_by_another_user?
    returned_by.present? && user != returned_by
  end

  def duration
    if loan_date && return_date
      return_date - loan_date
    end
  end
end
