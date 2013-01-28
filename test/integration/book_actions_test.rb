require 'integration_test_helper'

class BookActionsTest < ActionDispatch::IntegrationTest

  context "as a signed in user" do
    setup do
      sign_in_as_stub_user
    end

    context "given a book exists" do
      setup do
        @book = FactoryGirl.create(:book, :title => "The Wind in the Willows", :author => "Kenneth Grahame", :google_id => "mock-google-id")
      end

      should "see the book details" do
        visit "/books/#{@book.id}"

        within ".cover" do
          assert page.has_selector?("img[src='http://bks0.books.google.co.uk/books?id=mock-google-id&printsec=frontcover&img=1&zoom=1&edge=none&source=gbs_api']")
        end

        within ".title" do
          assert page.has_content?("The Wind in the Willows")
          assert page.has_content?("by Kenneth Grahame")
        end
      end

      should "see copies" do
        visit "/books/#{@book.id}"

        assert page.has_content?("1 copy")
        within ".copies li" do
          assert page.has_link?("#1", :href => "/copy/1")
          assert page.has_content?("Available to borrow")
          assert page.has_link?("Borrow", :href => "/copy/1/borrow")
        end
      end

      should "see the book history for a book with changes" do
        with_versioning do
          PaperTrail.whodunnit = FactoryGirl.create(:user, :name => "Mr Toad")
          @book.update_attributes!(:title => "Goodnight Mister Tom")

          visit "/books/#{@book.id}"
          click_on "See revision history"

          assert page.has_content?(@book.title)

          rows = page.all('table.history tr').map {|r| r.all('td').map(&:text).map(&:strip) }
          assert_equal [
            [ "Mr Toad", "less than a minute ago", "Title: Goodnight Mister Tom" ],
          ], rows
        end
      end

      should "see a message instead of book history for a book without any changes" do
        visit "/books/#{@book.id}"
        click_on "See revision history"

        assert page.has_content?(@book.title)
        assert page.has_content?("No changes have been made to this book yet.")
      end
    end
  end

end
