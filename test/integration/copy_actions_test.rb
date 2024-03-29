require "integration_test_helper"

class CopyActionsTest < ActionDispatch::IntegrationTest
  describe "a signed in user" do
    setup do
      sign_in_user_with_capybara
    end

    describe "given an available copy exists" do
      setup do
        @copy = FactoryBot.create(:copy, id: "123")
      end

      it "renders the copy page" do
        visit "/copy/123"

        assert page.has_content?("123")
        assert page.has_content?(@copy.book.title)
        assert page.has_content?("Available to borrow")
        assert page.has_content?("Borrow")
      end

      it "allows the book to be borrowed" do
        visit "/copy/123"
        click_on "Borrow"

        assert_equal "/copy/123", current_path
        assert page.has_content?("123")
        assert page.has_content?("On loan to you")
        assert page.has_content?("since #{Time.zone.today.strftime('%b %d, %Y')}")
      end

      it "does not display the loan history section if there are no previous loans" do
        visit "/copy/123"

        assert page.has_no_content?("Loan history")
      end

      it "links to the book page" do
        visit "/copy/123"
        assert page.has_link?("See all copies of this book", href: "/books/#{@copy.book.id}")
      end
    end

    describe "given a copy is on loan to the signed in user" do
      setup do
        @copy = FactoryBot.create(:copy, id: "123")
        @copy.borrow(signed_in_user)
      end

      it "renders the copy page" do
        visit "/copy/123"

        assert page.has_content?("123")
        assert page.has_content?(@copy.book.title)
        assert page.has_content?("On loan to you")
        assert page.has_content?("Return")
      end

      it "allows the book to be returned" do
        visit "/copy/123"
        click_on "Return"

        assert_equal "/copy/123", current_path
        assert page.has_content?("123")
        assert page.has_content?("Available to borrow")
      end
    end

    describe "given a copy is on loan to another user" do
      setup do
        @another_user = FactoryBot.create(:user, name: "O'Brien")
        @copy = FactoryBot.create(:copy, id: "123")
        @copy.borrow(@another_user)
      end

      it "renders the copy page" do
        visit "/copy/123"

        assert page.has_content?("123")
        assert page.has_content?(@copy.book.title)
        assert page.has_content?("On loan to O'Brien")
        assert page.has_content?("since #{Time.zone.today.strftime('%b %d, %Y')}")
      end

      it "allows the book to be returned" do
        visit "/copy/123"
        click_on "Return"

        assert_equal "/copy/123", current_path
        assert page.has_content?("123")
        assert page.has_content?("Available to borrow")

        within ".history" do
          assert page.has_content?(@another_user.name)
          assert page.has_content?("returned by #{signed_in_user.name}")
        end
      end
    end

    describe "given a copy which has been borrowed multiple times" do
      setup do
        @copy = FactoryBot.create(:copy, id: "53")

        @user1 = FactoryBot.create(:user, name: "Julia")
        @user2 = FactoryBot.create(:user, name: "Emmanuel Goldstein")

        @loans = [
          FactoryBot.create(:loan, copy: @copy, state: :returned, user_id: @user1.id, loan_date: Date.parse("1 January 2012").beginning_of_day, return_date: Date.parse("15 January 2012").beginning_of_day),
          FactoryBot.create(:loan, copy: @copy, state: :returned, user_id: @user2.id, loan_date: Date.parse("5 April 2012").beginning_of_day, return_date: Date.parse("1 May 2012").beginning_of_day),
          FactoryBot.create(:loan, copy: @copy, state: :returned, user_id: @user1.id, loan_date: Date.parse("17 June 2012").beginning_of_day, return_date: Date.parse("10 July 2012").beginning_of_day),
        ]
      end

      it "displays a list of previous loans" do
        visit "/copy/53"

        assert page.has_selector?("h2", text: "Loan history")

        rows = page.all("table.history tr").map { |r| r.all("th, td").map(&:text).map(&:strip) }
        assert_equal [
          ["From", "Until", "Duration", "by"],
          ["17 June 2012", "10 July 2012", "23 days", "Julia"],
          ["5 April 2012", "1 May 2012", "26 days", "Emmanuel Goldstein"],
          ["1 January 2012", "15 January 2012", "14 days", "Julia"],
        ], rows
      end

      it "links the name previous loaning user to their profile" do
        visit "/copy/53"

        assert page.has_link?("Julia", href: "/user/#{@user1.id}")
        assert page.has_link?("Emmanuel Goldstein", href: "/user/#{@user2.id}")
      end
    end
  end
end
