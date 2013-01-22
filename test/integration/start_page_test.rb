require 'integration_test_helper'

class StartPageTest < ActionDispatch::IntegrationTest

  context "as a signed in user" do
    setup do
      sign_in_as_stub_user
    end

    should "load the start page" do
      books = FactoryGirl.create_list(:book, 8)

      visit '/'

      assert page.has_content?("Welcome, #{stub_user.name}!")
      assert page.has_content?("You have 0 books on loan")

      within(".browse") do
        assert page.has_content?("Browse the library")

        within("ul.books_grid") do
          assert page.has_selector?('li', :count => 8)

          books.each do |book|
            assert page.has_selector?("img[alt=\"#{book.title} by #{book.author}\"]")
          end
        end
      end
    end

    should "update the number of items on loan" do
      loans = FactoryGirl.create_list(:loan, 5, :user => stub_user)

      visit '/'
      assert page.has_content?("You have 5 books on loan")
    end

    should "allow the user to look up a valid copy by id" do
      @copy = FactoryGirl.create(:copy, :book_reference => "123")

      visit '/'

      within ".start-form:first" do
        fill_in 'book_reference', :with => "123"
        click_on "Go"
      end

      assert "/copy/123", current_path
    end

    should "show an error when a user attempts to look up an invalid copy id" do
      visit '/'

      within ".start-form:first" do
        fill_in 'book_reference', :with => "999"
        click_on "Go"
      end

      assert "/", current_path
      assert page.has_content?("Copy 999 couldn't be found")
    end
  end



end
