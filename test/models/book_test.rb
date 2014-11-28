require 'test_helper'

describe Book do

  context "creating a book" do
    should "reject a blank ISBN" do
      book = Book.new(:isbn => '')

      assert ! book.valid?
    end

    should "create an initial copy upon creation" do
      book = FactoryGirl.create(:book)

      assert_equal 1, book.copies.count
    end

    should "set the creating user" do
      user = FactoryGirl.create(:user)
      book = FactoryGirl.create(:book, :created_by => user)

      assert_equal user.id, book.created_by.id
    end
  end

  context "editing a book" do
    context "changing the ISBN" do
      setup do
        @book = FactoryGirl.create(:book)
      end

      should "persist the new isbn" do
        @book.update_attributes(:isbn => "0140817743")
        @book.reload

        assert_equal "0140817743", @book.isbn
      end

      should "strip whitespace and dashes from the isbn" do
        @book.update_attributes(:isbn => "0 1408-177-43")
        @book.reload

        assert_equal "0140817743", @book.isbn
      end
    end
  end

end
