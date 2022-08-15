require "integration_test_helper"
require "book_metadata_lookup"

class BooksControllerTest < ActionDispatch::IntegrationTest
  before do
    sign_in_user
  end

  before do
    @book = FactoryBot.create(:book)
  end

  describe "listing the books on the index page" do
    before do
      @book_2 = FactoryBot.create(:book, title: "JavaScript: The Definitive Guide")
      FactoryBot.create(:book, title: "Effective Software Testing")
      FactoryBot.create(:book, title: "Practical Cloud Security")
    end

    it "returns a successful response" do
      get books_path

      assert_response :success
    end

    it "shows all books" do
      get books_path

      assert_select "h3", "availability"
      assert_select "img", 4
    end

    describe "searching for a book" do
      it "returns results for a title search" do
        get books_path(q: "JavaScript")

        assert_select "img", 1
        assert_match "JavaScript: The Definitive Guide", @response.body
      end

      it "does not return results when there are no matches" do
        get books_path(q: "Angular")

        assert_select "img", 0
      end
    end

    describe "filtering by availability" do
      it "only shows the books matching the availability category picked" do
        copy_one = @book_2.copies.first
        copy_one.set_missing

        get books_path(availability: "missing")

        assert_select "img", 1
        assert_match "JavaScript: The Definitive Guide", @response.body
      end
    end
  end

  describe "new book page" do
    it "returns a successful response" do
      get new_book_path

      assert_response :success
      assert_select "h1", "Add a book"
    end
  end

  describe "creating a book" do
    it "uses the isbn to look up the the details for a book" do
      isbn = "978-1492077213"

      BookMetadataLookup.expects(:find_by_isbn).with("9781492077213").returns({
        google_id: "CzfgzQEACAAJ",
        openlibrary_id: "OL33166635M",
        title: "Learning Go",
        author: "Jon Bodner",
      })

      post books_path, params: { intent: "isbn-lookup", book: { isbn: } }

      assert_response :success
      assert_select "h1", "Add a book"

      assert_select "#book_title[value=?]", "Learning Go"
      assert_select "#book_author[value=?]", "Jon Bodner"
      assert_select "#book_google_id[value=?]", "CzfgzQEACAAJ"
      assert_select "#book_openlibrary_id[value=?]", "OL33166635M"
    end

    it "shows an error if looking up the book by isbn fails" do
      isbn = "1"
      BookMetadataLookup.expects(:find_by_isbn).with(isbn).raises(BookMetadataLookup::BookNotFound)

      post books_path, params: { intent: "isbn-lookup", book: { isbn: } }

      assert_response :success
      assert_select "h1", "Add a book"
      assert_equal "Couldn't find book with isbn #{isbn}", flash[:alert]
    end

    it "saves the book and redirects" do
      title = "Program Arcade Games"

      assert_difference "Book.count" do
        post books_path, params: {
          book: { isbn: "9781484217894",
                  title:,
                  author: "Paul Craven" },
        }
      end
      follow_redirect!

      assert_select "h1", title
      assert_equal "Book created", flash[:notice]
    end

    it "shows an error if the title is blank" do
      assert_no_difference "Book.count" do
        post books_path, params: { book: { title: "", author: "A. Name" } }
      end

      assert_select "h1", "Add a book"
      assert_select "#book_title_input .inline-errors", "can't be blank"
    end

    it "shows an error if the author is blank" do
      assert_no_difference "Book.count" do
        post books_path, params: { book: { title: "My book", author: "" } }
      end

      assert_select "h1", "Add a book"
      assert_select "#book_author_input .inline-errors", "can't be blank"
    end

    it "shows an error if the isbn already exists" do
      FactoryBot.create(:book, title: "Original title", isbn: "1")

      assert_no_difference "Book.count" do
        post books_path, params: {
          book: { isbn: "1", title: "New title", author: "New Author" },
        }
      end

      assert_select "h1", "Add a book"
      assert_select "#book_isbn_input .inline-errors", "has already been taken"
    end
  end

  describe "viewing a single book" do
    it "returns a successful response" do
      get book_path(@book.id)

      assert_response :success
    end

    it "loads the book details" do
      get book_path(@book)

      assert_select "h1", @book.title
      assert_select "section.single_book"
    end
  end

  describe "edit book page" do
    it "renders the edit book page" do
      get edit_book_path(@book)

      assert_response :success
      assert_select "h1", "Edit book"
    end

    it "shows the edit book form with the details filled in" do
      get edit_book_path(@book)

      assert_select "#book_title[value=?]", @book.title
      assert_select "#book_author[value=?]", @book.author
      assert_select "#book_isbn[value=?]", @book.isbn
      assert_select "#book_google_id[value=?]", @book.google_id
      assert_select "#book_openlibrary_id[value=?]", @book.openlibrary_id
    end
  end

  describe "updating a book" do
    it "updates the book and redirects" do
      new_title = "Program Arcade Games"
      new_author = "Paul Craven"

      patch book_path(@book), params: { book: { title: new_title, author: new_author } }
      follow_redirect!

      assert_select "h1", new_title
      assert_select "h2", "by #{new_author}"
      assert_equal "Book updated", flash[:notice]
    end

    it "shows an error if the title is blank" do
      patch book_path(@book), params: { book: { title: "", author: "A. Name" } }

      assert_select "h1", "Edit book"
      assert_select "#book_title_input .inline-errors", "can't be blank"
      assert_equal @book.title, Book.last.title
    end

    it "shows an error if the author is blank" do
      patch book_path(@book), params: { book: { title: "My book", author: "" } }

      assert_select "h1", "Edit book"
      assert_select "#book_author_input .inline-errors", "can't be blank"
      assert_equal @book.author, Book.last.author
    end

    it "shows an error if the isbn already exists" do
      FactoryBot.create(:book, title: "Original title", isbn: "1")

      patch book_path(@book), params: {
        book: { isbn: "1", title: "New title", author: "New Author" },
      }

      assert_select "h1", "Edit book"
      assert_select "#book_isbn_input .inline-errors", "has already been taken"
      assert_not_equal @book.isbn, "1"
    end
  end
end
