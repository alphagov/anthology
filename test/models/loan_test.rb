# typed: false
require "test_helper"

describe Loan do
  setup do
    @copy = FactoryBot.create(:copy)
    @user = FactoryBot.create(:user)
  end

  context "creating a new loan" do
    should "require a user" do
      loan = @copy.loans.build(user: nil)

      assert_not loan.valid?
    end

    should "set the state to 'on_loan' by default" do
      loan = @copy.loans.create!(user: @user)

      assert_equal "on_loan", loan.state
    end

    should "set the loan date by default" do
      loan = @copy.loans.create!(user: @user)

      assert_not loan.loan_date.blank?
    end

    should "set the copy on_loan attribute to true" do
      @copy.loans.create!(user: @user)
      @copy.reload

      assert @copy.on_loan?
    end
  end

  context "returning a loan" do
    setup do
      @loan = @copy.loans.create!(user: @user)
    end

    should "update the state to returned" do
      @loan.return

      assert_equal "returned", @loan.state
    end

    should "set the copy on_loan attribute to false" do
      @loan.return
      @copy.reload

      assert_not @copy.on_loan?
    end

    should "raise an exception if already returned" do
      @loan.return

      assert_raises Loan::NotOnLoan do
        @loan.return
      end
    end

    should "set the return date for the loan" do
      @loan.return

      assert_not @loan.return_date.blank?
    end

    should "set the returning user when present" do
      returning_user = create(:user)
      @loan.return(returning_user)

      @loan.reload
      assert_equal returning_user, @loan.returned_by
    end

    should "set the returning shelf when present" do
      shelf = Shelf.first
      @loan.return(nil, shelf)

      @loan.reload
      assert_equal shelf, @loan.returned_to_shelf
    end
  end
end
