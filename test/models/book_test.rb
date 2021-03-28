require "test_helper"

describe Book do
  context "creating a book" do
    should "require an author" do
      book = Book.new

      assert_not book.valid?
      assert_equal ["can't be blank"], book.errors[:author]
    end

    should "require a title" do
      book = Book.new

      assert_not book.valid?
      assert_equal ["can't be blank"], book.errors[:title]
    end

    should "require a unique ISBN number" do
      Book.create!(title: "The Sign of the Four", author: "Conan Doyle", isbn: "abc 123")
      book_two = Book.new(title: "A Study in Scarlet", author: "Conan Doyle", isbn: "ABC-123")

      assert_not book_two.valid?
      assert_equal ["has already been taken"], book_two.errors[:isbn]
    end

    should "create an initial copy upon creation" do
      book = FactoryBot.create(:book)

      assert_equal 1, book.copies.count
    end

    should "set the creating user" do
      user = FactoryBot.create(:user)
      book = FactoryBot.create(:book, created_by: user)

      assert_equal user.id, book.created_by.id
    end
  end

  context "editing a book" do
    context "changing the ISBN" do
      setup do
        @book = FactoryBot.create(:book)
      end

      should "persist the new isbn" do
        @book.update!(isbn: "0140817743")
        @book.reload

        assert_equal "0140817743", @book.isbn
      end

      should "strip whitespace and dashes from the isbn" do
        @book.update!(isbn: "0 1408-177-43")
        @book.reload

        assert_equal "0140817743", @book.isbn
      end
    end
  end
end
