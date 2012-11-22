require 'test_helper'

class LoanTest < ActiveSupport::TestCase

  setup do
    @copy = FactoryGirl.create(:copy)
    @user = FactoryGirl.create(:user)
  end

  context "creating a new loan" do
    should "require a user" do
      loan = @copy.loans.build(:user => nil)

      assert !loan.valid?
    end

    should "set the state to 'on_loan' by default" do
      loan = @copy.loans.create!(:user => @user)

      assert_equal "on_loan", loan.state
    end

    should "set the loan date by default" do
      loan = @copy.loans.create!(:user => @user)

      assert ! loan.loan_date.blank?
    end

    should "set the copy on_loan attribute to true" do
      loan = @copy.loans.create!(:user => @user)
      @copy.reload

      assert @copy.on_loan?
    end
  end

  context "returning a loan" do
    setup do
      @loan = @copy.loans.create!(:user => @user)
    end

    should "update the state to returned" do
      @loan.return

      assert_equal "returned", @loan.state
    end

    should "set the copy on_loan attribute to false" do
      @loan.return
      @copy.reload

      assert ! @copy.on_loan?
    end

    should "raise an exception if already returned" do
      @loan.return

      assert_raises Loan::NotOnLoan do
        @loan.return
      end
    end
  end

end
