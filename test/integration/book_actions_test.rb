require "integration_test_helper"

class BookActionsTest < ActionDispatch::IntegrationTest
  describe "a signed in user" do
    setup do
      sign_in_user_with_capybara
    end

    describe "given a book exists" do
      setup do
        @book = FactoryBot.create(:book, title: "The Wind in the Willows", author: "Kenneth Grahame", google_id: "mock-google-id")
      end

      it "shows the book details" do
        visit "/books/#{@book.id}"

        within ".cover" do
          assert page.has_selector?("img[src='https://books.google.co.uk/books?id=mock-google-id&printsec=frontcover&img=1&zoom=1&edge=none&source=gbs_api']")
        end

        within ".title" do
          assert page.has_content?("The Wind in the Willows")
          assert page.has_content?("by Kenneth Grahame")
        end
      end

      it "shows a book's copies" do
        visit "/books/#{@book.id}"

        assert page.has_content?("1 copy")

        copy_id = @book.copies.first.id

        within ".copies li" do
          assert page.has_link?("##{copy_id}", href: "/copy/#{copy_id}")
          assert page.has_content?("Available to borrow")
          assert page.has_link?("Borrow", href: "/copy/#{copy_id}/borrow")
        end
      end

      it "displays the book history for a book with changes" do
        with_versioning do
          PaperTrail.request.whodunnit = FactoryBot.create(:user, name: "Mr Toad").id.to_s
          @book.update!(title: "Goodnight Mister Tom")

          visit "/books/#{@book.id}"
          click_on "See revision history"

          assert page.has_content?(@book.title)

          rows = page.all("table.history tr").map { |r| r.all("td").map(&:text).map(&:strip) }
          assert_equal [
            ["Mr Toad", "less than a minute ago", "Title: Goodnight Mister Tom"],
          ], rows
        end
      end

      it "displays a message instead of book history for a book without any changes" do
        visit "/books/#{@book.id}"
        click_on "See revision history"

        assert page.has_content?(@book.title)
        assert page.has_content?("No changes have been made to this book yet.")
      end
    end
  end
end
