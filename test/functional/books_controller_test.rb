require 'test_helper'

class BooksControllerTest < ActionController::TestCase

  setup do
    login_as_stub_user
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

    should "render the grid view by default" do
      get :index
      assert_template "grid"
    end

    should "render the list view when given a display=list parameter" do
      get :index, :display => 'list'
      assert_template "list"
    end

    should "fallback to the grid view if display is not list" do
      get :index, :display => :foo
      assert_template "grid"
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

end
