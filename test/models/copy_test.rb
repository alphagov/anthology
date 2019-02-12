require 'test_helper'

describe Copy do

  setup do
    @book = FactoryBot.create(:book)
  end

  should "return the book reference as the url parameter" do
    copy = FactoryBot.create(:copy, :book_reference => "123")
    assert_equal "123", copy.to_param
  end

  context "creating a new copy" do
    should "increment the book reference" do
      first_copy = @book.copies.first # already created on book creation
      second_copy = @book.copies.create!(:book_reference => 2)
      third_copy = @book.copies.create!

      assert_equal 1, first_copy.book_reference.to_i
      assert_equal 2, second_copy.book_reference.to_i
      assert_equal 3, third_copy.book_reference.to_i
    end

    should "not allow duplicate book references" do
      first_copy = @book.copies.create!(:book_reference => 30)
      second_copy = @book.copies.build(:book_reference => 30)

      assert_equal 30, first_copy.book_reference.to_i
      assert ! second_copy.valid?
    end

    should "set on_loan to false by default" do
      copy = @book.copies.create!

      assert_equal false, copy.on_loan
    end

    should "have no loans by default" do
      copy = @book.copies.create!

      assert_equal 0, copy.loans.count
    end
  end

  context "borrowing a book" do
    setup do
      @user = FactoryBot.create(:user)
    end

    should "not allow a book already on loan to be borrowed" do
      copy = FactoryBot.create(:copy_on_loan)

      assert_raise Copy::NotAvailable do
        copy.borrow(@user)
      end
    end

    should "create a new loan" do
      copy = FactoryBot.create(:copy)
      copy.borrow(@user)

      assert_equal 1, copy.loans.count
    end

    should "find the current loan" do
      copy = FactoryBot.create(:copy)
      copy.borrow(@user)

      assert_equal copy.current_loan, copy.loans.first
      assert_equal copy.current_loan.user_id, @user.id
    end

    should "find the current user" do
      copy = FactoryBot.create(:copy)
      copy.borrow(@user)

      assert_equal @user.id, copy.current_user.id
    end
  end

  context "returning a copy" do
    setup do
      @copy_on_loan = FactoryBot.create(:copy_on_loan)
      @user = @copy_on_loan.current_user
    end

    should 'return the loans attached to the copy' do
      loan = @copy_on_loan.loans.where(state: 'on_loan').first

      @copy_on_loan.return

      @copy_on_loan.reload
      loan.reload

      assert_equal 'returned', loan.state
      assert_equal false, @copy_on_loan.on_loan
    end

    should "not allow a copy not on loan to be returned" do
      copy = FactoryBot.create(:copy)

      assert_raise Copy::NotOnLoan do
        copy.return
      end
    end

    should "only try to return current loans" do
      previous_loan = @copy_on_loan.loans.create!(:user => @user, :state => 'returned')
      previous_loan.expects(:return).never

      assert @copy_on_loan.return
    end

    should 'pass through the returning user when present' do
      user = create(:user)
      Loan.any_instance.expects(:return).with(user, shelf=nil).returns(true)

      assert @copy_on_loan.return(user)
    end
  end

  context "shelves" do
    should "be able to set the shelf" do
      copy = FactoryBot.create(:copy)
      copy.update_attributes(shelf_id: 1)

      copy.reload

      assert_equal 1, copy.shelf_id
    end
  end


  context "recently added copies" do
    should "return newest copies first" do
      # delete first auto-generated copy of book
      @book.copies.delete_all

      copies = [
        FactoryBot.create(:copy, :book_reference => 101, :book => @book),
        FactoryBot.create(:copy, :book_reference => 201, :book => @book),
        FactoryBot.create(:copy, :book_reference => 301, :book => @book)
      ]
      assert_equal 301, Copy.recently_added.first.book_reference
      assert_equal 101, Copy.recently_added.last.book_reference
    end
  end

end
