require 'integration_test_helper'

class CopyActionsTest < ActionDispatch::IntegrationTest

  context "as a signed in user" do
    setup do
      sign_in_as_stub_user
    end

    context "given an available copy exists" do
      setup do
        @copy = FactoryGirl.create(:copy, :book_reference => "123")
      end

      should "render the copy page" do
        visit "/copy/123"

        assert page.has_content?("123")
        assert page.has_content?(@copy.book.title)
        assert page.has_content?("Available to borrow")
        assert page.has_content?("Borrow")
      end

      should "allow the book to be borrowed" do
        visit "/copy/123"
        click_on "Borrow"

        assert_equal "/copy/123", current_path
        assert page.has_content?("123")
        assert page.has_content?("On loan to you")
        assert page.has_content?("since #{Date.today.strftime("%b %d, %Y")}")
      end

      should "link to the book page" do
        visit "/copy/123"
        assert page.has_link?("See all copies of this book", :href => "/books/#{@copy.book.id}")
      end
    end # given an available copy exists

    context "given a copy is on loan to the signed in user" do
      setup do
        @copy = FactoryGirl.create(:copy, :book_reference => "123")
        @copy.borrow(stub_user)
      end

      should "render the copy page" do
        visit "/copy/123"

        assert page.has_content?("123")
        assert page.has_content?(@copy.book.title)
        assert page.has_content?("On loan to you")
        assert page.has_content?("Return")
      end

      should "allow the book to be returned" do
        visit "/copy/123"
        click_on "Return"

        assert_equal "/copy/123", current_path
        assert page.has_content?("123")
        assert page.has_content?("Available to borrow")
      end
    end

    context "given a copy is on loan to another user" do
      setup do
        @another_user = FactoryGirl.create(:user, :name => "O'Brien")
        @copy = FactoryGirl.create(:copy, :book_reference => "123")
        @copy.borrow(@another_user)
      end

      should "render the copy page" do
        visit "/copy/123"

        assert page.has_content?("123")
        assert page.has_content?(@copy.book.title)
        assert page.has_content?("On loan to O'Brien")
        assert page.has_content?("since #{Date.today.strftime("%b %d, %Y")}")
      end

      should "not allow the book to be returned" do
        visit "/copy/123"

        assert page.has_no_content?("Return")
      end
    end
  end # as signed in user
end
