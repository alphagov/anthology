require "integration_test_helper"

class StartPageTest < ActionDispatch::IntegrationTest
  describe "as a signed in user" do
    setup do
      sign_in_user_with_capybara
    end

    it "loads the start page" do
      FactoryBot.create_list(:book, 8)

      visit "/"

      assert page.has_content?("Welcome, #{signed_in_user.name}!")
      assert page.has_content?("You have 0 books on loan")
    end

    it "updates the number of items on loan" do
      FactoryBot.create_list(:loan, 5, user: signed_in_user)

      visit "/"
      assert page.has_content?("You have 5 books on loan")
    end

    it "allows the user to look up a valid copy by id" do
      FactoryBot.create(:copy, id: "123")

      visit "/"

      within ".copy-lookup" do
        fill_in "id", with: "123"
        click_on "Go"
      end

      assert_equal "/copy/123", current_path
    end

    it "shows an error when a user attempts to look up an invalid copy id" do
      visit "/"

      within ".copy-lookup" do
        fill_in "id", with: "999"
        click_on "Go"
      end

      assert_equal "/", current_path
      assert page.has_content?("Copy 999 couldn't be found")
    end

    it "allows the user to look up a book by title" do
      FactoryBot.create(:book, title: "first title")
      FactoryBot.create(:book, title: "second title")
      FactoryBot.create(:book, title: "third title")

      visit "/"

      within ".title-lookup" do
        fill_in "query", with: "first"
        click_on "Go"
      end

      assert_equal "/books", current_path
      assert_equal 1, page.find_all("img").length
    end

    it "displays recently added copies added to the library" do
      @book = FactoryBot.create(:book, title: "The Lion, the Witch and the Wardrobe")
      @older_copies = FactoryBot.create_list(:copy, 10)
      @copy = FactoryBot.create(:copy, id: "12345", book: @book)
      visit "/"
      within ".recently-added" do
        within "li:first" do
          assert page.has_selector?("img[alt^='The Lion, the Witch and the Wardrobe']")
          assert page.has_selector?("a[href='/copy/12345']")
        end
      end
    end

    it "displays recent loans from the library" do
      copies_on_loan = FactoryBot.create_list(:copy_on_loan, 5)

      visit "/"
      within ".recent-activity ul" do
        copies_on_loan.reverse.each_with_index do |copy, i|
          within "li:nth-of-type(#{i + 1})" do
            assert page.has_content?("#{copy.current_user.name} borrowed ##{copy.id}: #{copy.book.title}")
            assert page.has_selector?("a[href='/user/#{copy.current_user.id}']")
            assert page.has_selector?("a[href='/copy/#{copy.id}']")
          end
        end
      end

      assert page.has_content?("Recent loans")
    end
  end
end
