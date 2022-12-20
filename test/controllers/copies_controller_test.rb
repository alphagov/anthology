require "integration_test_helper"

class CopiesControllerTest < ActionDispatch::IntegrationTest
  before do
    sign_in_user
    @copy = FactoryBot.create(:copy)
  end

  describe "viewing a copy" do
    it "shows the copy" do
      get copy_path(@copy)

      assert_response :success
      assert_select "h1", "##{@copy.id} #{@copy.book.title}"

      assert_select "span.location a", { text: "set" }
      assert_select "a.btn", { text: "Borrow" }
    end
  end

  describe "adding a new copy" do
    before do
      @book = FactoryBot.create(:book)
    end

    it "shows the page to add a copy of an existing book" do
      get new_book_copy_path(@book)

      assert_response :success
      assert_select "h1", "Add a new copy of #{@book.title}"

      # location dropdown contains "unknown" plus 2 entries from the seeded data
      assert_select "form select option", 3
      assert_select "[value=?]", "Add this copy"
    end

    it "saves the copy and redirects" do
      assert_difference "Copy.count" do
        post book_copies_path(@book), params: { copy: { "location_id": "" } }
      end

      assert_redirected_to book_path(@book)
      assert_equal "Copy #{Copy.last.id} has been added to the library.", @controller.flash[:notice]
    end
  end

  describe "editing a copy" do
    it "shows the existing copy with a form to set its location" do
      get edit_copy_path(@copy)

      assert_response :success
      assert_select "h1", @copy.book.title

      # location dropdown contains "unknown" plus 2 entries from the seeded data
      assert_select "form select option", 3
      assert_select "[value=?]", "Set location"
    end

    it "updates the copy's location" do
      assert_nil @copy.location

      patch copy_path(@copy), params: { copy: { location_id: "1" } }
      @copy.reload

      assert_equal 1, @copy.location.id
      assert_redirected_to copy_path(@copy)
      assert_equal "Location updated", flash[:notice]
    end
  end

  describe "looking up a copy" do
    it "redirects to the copy page if the copy exists" do
      post lookup_copy_index_path, params: { id: @copy.id }

      assert_redirected_to copy_path(@copy)
    end

    it "shows an error if the copy does not exist" do
      post lookup_copy_index_path, params: { id: "6789" }

      assert_redirected_to root_path
      assert_equal "Copy 6789 couldn't be found.", @controller.flash[:alert]
    end
  end

  describe "borrowing and returning" do
    it "borrowing creates a new loan" do
      assert_difference "Loan.count" do
        post borrow_copy_path(@copy)
      end

      assert_redirected_to copy_path(@copy)
      assert_equal "Copy #{@copy.id} is now on loan to you.", @controller.flash[:notice]
    end

    it "shows an error if trying to borrow a book already on loan" do
      user = FactoryBot.create(:user)
      @copy.borrow user

      post borrow_copy_path(@copy)

      assert_redirected_to copy_path(@copy)
      assert_equal "Copy #{@copy.id} is already on loan to #{user.name}.", @controller.flash[:alert]
    end

    it "returns a copy to a set location" do
      return_location = Location.find("1")
      copy_on_loan = FactoryBot.create(:copy_on_loan)
      current_loan = Loan.last

      assert_equal "on_loan", current_loan.state

      post return_copy_path(copy_on_loan), params: { copy: { location_id: return_location.id } }
      copy_on_loan.reload
      current_loan.reload

      assert_equal "returned", current_loan.state
      assert_equal return_location, copy_on_loan.location
      assert_redirected_to copy_path(copy_on_loan)
      assert_equal "Copy #{copy_on_loan.id} has now been returned to #{return_location.name}. Thanks!", @controller.flash[:notice]
    end

    it "returns a copy to an unknown location" do
      copy_on_loan = FactoryBot.create(:copy_on_loan)
      current_loan = Loan.last

      assert_equal "on_loan", current_loan.state

      post return_copy_path(copy_on_loan), params: { copy: { location_id: "" } }
      copy_on_loan.reload
      current_loan.reload

      assert_equal "returned", current_loan.state
      assert_nil copy_on_loan.location
      assert_redirected_to copy_path(copy_on_loan)
      assert_equal "Copy #{copy_on_loan.id} has now been returned. Thanks!", @controller.flash[:notice]
    end

    it "shows an error if the copy is not on loan" do
      post return_copy_path(@copy), params: { copy: { location_id: "1" } }

      assert_not @copy.on_loan
      assert_redirected_to copy_path(@copy)
      assert_equal "Copy #{@copy.id} is not on loan.", @controller.flash[:alert]
    end
  end

  describe "setting and unsetting as missing" do
    it "sets a book as missing" do
      put missing_copy_path(@copy)
      @copy.reload

      assert_redirected_to copy_path(@copy)
      assert_equal "Copy ##{@copy.id} has been marked as missing", @controller.flash[:notice]
      assert @copy.missing
    end

    it "unsets a book as missing" do
      missing_copy = FactoryBot.create(:copy, missing: true)

      delete missing_copy_path(missing_copy)
      missing_copy.reload

      assert_redirected_to copy_path(missing_copy)
      assert_equal "Copy ##{missing_copy.id} is no longer marked as missing", @controller.flash[:notice]
      assert_not missing_copy.missing
    end
  end
end
