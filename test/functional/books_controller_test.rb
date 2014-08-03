require 'test_helper'

class BooksControllerTest < ActionController::TestCase

  setup do
    stub_user_session
  end

  context "book list" do
    setup do
      @books = [
        FactoryGirl.create(:book, :title => "Harry Potter and the Chamber of Secrets"),
        FactoryGirl.create(:book, :title => "The Hobbit"),
        FactoryGirl.create(:book, :title => "Nineteen Eighty-Four")
      ]
    end

    should "return a successful response" do
      get :index
      assert response.success?
    end

    should "initialize a list of books" do
      get :index
      assert_equal 3, assigns(:books).length
      assert_equal @books.map(&:title).sort, assigns(:books).map(&:title).sort
    end

    should "render the index view" do
      get :index
      assert_template "index"
    end

    context "searching for a book" do
      should "return results for a title search" do
        get :index, :q => "Harry"
        assert_equal "Harry Potter and the Chamber of Secrets", assigns(:books).first.title
      end

      should "not return results when there are no matches" do
        get :index, :q => "Lord Voldermort"
        assert_equal 0, assigns(:books).length
      end
    end
  end

  context "new book form" do
    should "render the form" do
      get :new
      assert_template "new"
    end

    should "return a successful response" do
      get :new
      assert response.success?
    end

    should "assign an new book object" do
      get :new

      assert_instance_of Book, assigns(:book)
      assert_nil assigns(:book).title
    end
  end

  context "looking up isbns" do
    should "raise a not found error if isbn is blank" do
      assert_raise(ActionController::RoutingError) do
        get :lookup_isbn, :isbn => ''
      end
    end

    should "invoke the metadata lookup library for a valid request" do
      BookMetadataLookup.expects(:find_by_isbn).with("12345").returns({})

      get :lookup_isbn, :isbn => "12345"
      assert_response :success
    end

    should "be forgiving of the input" do
      BookMetadataLookup.expects(:find_by_isbn).with("12345").returns({})

      get :lookup_isbn, :isbn => "123-4-5"
      assert_response :success
    end
  end

  context "a single book" do
    setup do
      @book = FactoryGirl.create(:book)
    end

    should "return a successful response" do
      get :show, :id => @book.id
      assert response.success?
    end

    should "load the book details" do
      get :show, :id => @book.id

      assert_equal @book.id, assigns(:book).id
      assert_equal @book.title, assigns(:book).title
      assert_equal @book.author, assigns(:book).author
    end

    should "render the show template" do
      get :show, :id => @book.id

      assert_template "books/show"
    end
  end

end
