require "integration_test_helper"

class RootControllerTest < ActionDispatch::IntegrationTest
  before do
    post "/auth/google"
    follow_redirect!
  end

  describe "the start page" do
    it "returns a successful response" do
      get root_path

      assert_match(/Welcome, Stub User!/, @response.body)
      assert_response :success
    end
  end

  describe "the library csv page" do
    it "generates a CSV file with a row for each book" do
      FactoryBot.create(:book, id: 1, title: "Book 1", author: "A. One", isbn: "1")
      FactoryBot.create(:book, id: 2, title: "Book 2", author: "A. Two", isbn: "2")

      get library_csv_path

      assert_response :success
      assert_equal "text/csv", @response.media_type

      csv_data = "id,title,author,isbn,number_of_copies,on_loan_copies\n" \
                  "1,Book 1,A. One,1,1,0/1\n2,Book 2,A. Two,2,1,0/1\n"

      assert_equal csv_data, @response.body
    end
  end
end
