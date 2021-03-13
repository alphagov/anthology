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
      assert ["can't be blank"], loan.errors[:user]
    end

    should "require a copy" do
      loan = FactoryBot.build(:loan, copy: nil, user: @user)

      assert_not loan.valid?
      assert ["can't be blank"], loan.errors[:copy]
    end

    should "set the state to 'on_loan' by default" do
      loan = @copy.loans.create!(user: @user)

      assert_equal "on_loan", loan.state
    end

    should "set the loan date by default" do
      travel_to Time.zone.local(2021, 2, 1, 15, 44) do
        @loan = @copy.loans.create!(user: @user)
      end

      assert_equal Time.zone.local(2021, 2, 1, 15, 44), @loan.loan_date
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
      travel_to Time.zone.local(2021, 3, 3, 12, 59) do
        @loan.return
      end

      assert_equal Time.zone.local(2021, 3, 3, 12, 59), @loan.return_date
    end

    should "set the returning user when present" do
      returning_user = create(:user)
      @loan.return(returning_user)

      @loan.reload
      assert_equal returning_user, @loan.returned_by
    end

    should "returned_by_another_user? is true if returned by a different user" do
      returning_user = create(:user)
      @loan.return(returning_user)
      @loan.reload

      assert @loan.returned_by_another_user?
    end

    should "returned_by_another_user? is false if returned by the same user" do
      returning_user = @loan.user
      @loan.return(returning_user)
      @loan.reload

      assert_not @loan.returned_by_another_user?
    end

    should "set the returning shelf when present" do
      shelf = Shelf.first
      @loan.return(nil, shelf)

      @loan.reload
      assert_equal shelf, @loan.returned_to_shelf
    end

    should "measure the loan duration" do
      @loan.loan_date = Time.zone.local(2021, 1, 1)
      @loan.return_date = Time.zone.local(2021, 2, 1, 12, 0)

      assert_equal 2_721_600.0, @loan.duration
    end
  end
end
