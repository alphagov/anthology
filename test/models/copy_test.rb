require "test_helper"

describe Copy do
  setup do
    @book = FactoryBot.create(:book)
  end

  describe "creating a new copy" do
    it "sets on_loan to false by default" do
      copy = @book.copies.create!

      assert_equal false, copy.on_loan
    end

    it "has no loans by default" do
      copy = @book.copies.create!

      assert_equal 0, copy.loans.count
    end
  end

  describe "borrowing a book" do
    setup do
      @user = FactoryBot.create(:user)
    end

    it "does not allow a book already on loan to be borrowed" do
      copy = FactoryBot.create(:copy_on_loan)

      assert_raises Copy::NotAvailable do
        copy.borrow(@user)
      end
    end

    it "creates a new loan" do
      copy = FactoryBot.create(:copy)
      copy.borrow(@user)

      assert_equal 1, copy.loans.count
    end

    it "finds the current loan" do
      copy = FactoryBot.create(:copy)
      copy.borrow(@user)

      assert_equal copy.current_loan, copy.loans.first
      assert_equal copy.current_loan.user_id, @user.id
    end

    it "finds the current user" do
      copy = FactoryBot.create(:copy)
      copy.borrow(@user)

      assert_equal @user.id, copy.current_user.id
    end
  end

  describe "returning a copy" do
    setup do
      @copy_on_loan = FactoryBot.create(:copy_on_loan)
      @user = @copy_on_loan.current_user
    end

    it "returns the loans attached to the copy" do
      loan = @copy_on_loan.loans.where(state: "on_loan").first

      @copy_on_loan.return

      @copy_on_loan.reload
      loan.reload

      assert_equal "returned", loan.state
      assert_equal false, @copy_on_loan.on_loan
    end

    it "does not allow a copy not on loan to be returned" do
      copy = FactoryBot.create(:copy)

      assert_raises Copy::NotOnLoan do
        copy.return
      end
    end

    it "only tries to return current loans" do
      previous_loan = @copy_on_loan.loans.create!(user: @user, state: "returned")
      previous_loan.expects(:return).never

      assert @copy_on_loan.return
    end

    it "passes through the returning user when present" do
      user = create(:user)
      Loan.any_instance.expects(:return).with(user, nil)

      assert @copy_on_loan.return(user)
    end

    it "returns the copy to the specified location" do
      user = create(:user)
      location = Location.first

      Loan.any_instance.expects(:return).with(user)

      @copy_on_loan.return(user, location)
      assert_equal location, @copy_on_loan.location
    end
  end

  describe "the location of copies" do
    it "is possible to update a copy's location" do
      copy = FactoryBot.create(:copy)
      copy.update!(location_id: 1)

      copy.reload

      assert_equal 1, copy.location_id
    end
  end

  describe "recently added copies" do
    it "returns newest copies first" do
      # delete first auto-generated copy of book
      @book.copies.delete_all

      FactoryBot.create(:copy, id: 101, book: @book)
      FactoryBot.create(:copy, id: 201, book: @book)
      FactoryBot.create(:copy, id: 301, book: @book)
      assert_equal 301, Copy.recently_added.first.id
      assert_equal 101, Copy.recently_added.last.id
    end
  end
end
