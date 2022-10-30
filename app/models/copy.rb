class Copy < ApplicationRecord
  belongs_to :book
  has_many :loans, dependent: :destroy
  has_many :users, through: :loans
  belongs_to :location

  scope :on_loan, -> { where(on_loan: true) }
  scope :available, -> { where(on_loan: false) }
  scope :missing, -> { where(missing: true) }

  scope :ordered_by_availability, -> { order("on_loan ASC, id ASC") }
  scope :recently_added, -> { order("created_at DESC") }

  class NotAvailable < RuntimeError; end

  class NotOnLoan < RuntimeError; end

  def current_loan
    loans.on_loan.first
  end

  def current_user
    current_loan.user if current_loan
  end

  def on_loan?
    on_loan && current_loan.present?
  end

  def available?
    !on_loan?
  end

  def status
    on_loan? ? :on_loan : :available
  end

  def missing?
    missing
  end

  def update_loan_status!
    self.on_loan = current_loan.present?
    save!
  end

  def borrow(user)
    raise NotAvailable unless available?

    loans.create!(user:)
  end

  def return(as_user = nil, to_location = nil)
    raise NotOnLoan unless on_loan?

    loans.where(state: "on_loan").find_each do |loan|
      loan.return(as_user)
    end

    self.location = to_location
    save!
  end

  def set_missing
    update(missing: true)
  end

  def unset_missing
    update(missing: false)
  end
end
