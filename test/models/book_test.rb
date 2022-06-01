require "test_helper"

describe Book do
  describe "creating a book" do
    it "requires an author" do
      book = Book.new

      assert_not book.valid?
      assert_equal ["can't be blank"], book.errors[:author]
    end

    it "requires a title" do
      book = Book.new

      assert_not book.valid?
      assert_equal ["can't be blank"], book.errors[:title]
    end

    it "requires a unique ISBN number" do
      Book.create!(title: "The Sign of the Four", author: "Conan Doyle", isbn: "abc 123")
      book_two = Book.new(title: "A Study in Scarlet", author: "Conan Doyle", isbn: "ABC-123")

      assert_not book_two.valid?
      assert_equal ["has already been taken"], book_two.errors[:isbn]
    end

    it "creates an initial copy upon creation" do
      book = FactoryBot.create(:book)

      assert_equal 1, book.copies.count
    end

    it "sets the creating user" do
      user = FactoryBot.create(:user)
      book = FactoryBot.create(:book, created_by: user)

      assert_equal user.id, book.created_by.id
    end
  end

  describe "editing a book" do
    describe "changing the ISBN" do
      setup do
        @book = FactoryBot.create(:book)
      end

      it "persists the new isbn" do
        @book.update!(isbn: "0140817743")
        @book.reload

        assert_equal "0140817743", @book.isbn
      end

      it "strips whitespace and dashes from the isbn" do
        @book.update!(isbn: "0 1408-177-43")
        @book.reload

        assert_equal "0140817743", @book.isbn
      end
    end
  end
end
