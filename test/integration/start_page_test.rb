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

    should "display recently added copies added to the library" do
      @book = FactoryGirl.create(:book, :title => "The Lion, the Witch and the Wardrobe")
      @older_copies = FactoryGirl.create_list(:copy, 10)
      @copy = FactoryGirl.create(:copy, :book_reference => "123", :book => @book)

      visit '/'
      within '.recently-added' do
        within 'li:first' do
          assert page.has_selector?("img[alt^='The Lion, the Witch and the Wardrobe']")
          assert page.has_selector?("a[href='/copy/123']")
        end
      end
    end

    should "display recent loans from the library" do
      copies_on_loan = FactoryGirl.create_list(:copy_on_loan, 5)

      visit '/'
      within '.recent-activity' do
        copies_on_loan.reverse.each_with_index do |copy, i|
          within "li:nth-child(#{i+1})" do
            assert page.has_content?("#{copy.current_user.name} borrowed ##{copy.book_reference}: #{copy.book.title}")
            assert page.has_selector?("a[href='/user/#{copy.current_user.id}']")
            assert page.has_selector?("a[href='/copy/#{copy.book_reference}']")
          end
        end
      end

      assert page.has_content?("Recent loans")
    end
  end
end
