class Loan < ActiveRecord::Base
  attr_accessible :user, :user_id, :copy_id, :state, :loan_date, :return_date

  belongs_to :copy
  belongs_to :user

  has_one :book, :through => :copy

  scope :on_loan, where(:state => 'on_loan')
  scope :returned, where(:state => 'returned')

  validates :user, :presence => true
  validates :copy, :presence => true

  before_create :set_loan_date
  after_save :update_copy_loan_status

  class NotOnLoan < Exception; end

  def return
    raise NotOnLoan unless state == "on_loan"

    self.state = 'returned'
    self.save
  end

  def set_loan_date
    self.loan_date = Time.now
  end

  def update_copy_loan_status
    copy.update_loan_status!
  end
end
