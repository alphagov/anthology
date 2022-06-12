require "integration_test_helper"

class BooksControllerTest < ActionDispatch::IntegrationTest
  before do
    post "/auth/google"
    follow_redirect!
  end

  describe "listing the books on the index page" do
    before do
      FactoryBot.create(:book, title: "JavaScript: The Definitive Guide")
      FactoryBot.create(:book, title: "Effective Software Testing")
      FactoryBot.create(:book, title: "Practical Cloud Security")
    end

    it "returns a successful response" do
      get books_path

      assert_response :success
    end

    it "initializes a list of books" do
      get books_path

      assert_select "h3", "availability"
      assert_select "img", 3
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
  end

  describe "new book page" do
    it "returns a successful response" do
      get new_book_path

      assert_response :success
    end
  end

  describe "viewing a single book" do
    before do
      @book = FactoryBot.create(:book)
    end

    it "returns a successful response" do
      get book_path(@book.id)

      assert_response :success
    end

    it "loads the book details" do
      get book_path(@book.id)

      assert_select "section.single_book"
    end
  end
end
