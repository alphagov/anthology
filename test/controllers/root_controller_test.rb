require "test_helper"

describe RootController do
  setup do
    stub_user_session
  end

  describe "the start page" do
    setup do
      # create some books
      FactoryBot.create_list(:book, 8)
    end

    it "returns a successful response" do
      get :start

      assert response.successful?
    end

    it "loads eight books to display to the user" do
      get :start

      assert_equal 8, assigns(:books).count
      assert_instance_of Book, assigns(:books).first
    end

    it "loads 3 recently added copies to display to the user" do
      get :start

      assert_equal 3, assigns(:recently_added_copies).count
      assert_instance_of Copy, assigns(:recently_added_copies).first
    end

    it "renders the start template" do
      get :start

      assert_template "start"
    end
  end

  describe "the library csv page" do
    it "generates a CSV file with a row for each book" do
      FactoryBot.create(:book, id: 1, title: "Book 1", author: "A. One", isbn: "1")
      FactoryBot.create(:book, id: 2, title: "Book 2", author: "A. Two", isbn: "2")

      get :library_csv

      assert_response :success
      assert_equal "text/csv", @response.media_type

      csv_data = "id,title,author,isbn,number_of_copies,on_loan_copies\n" \
                  "1,Book 1,A. One,1,1,0/1\n2,Book 2,A. Two,2,1,0/1\n"

      assert_equal csv_data, @response.body
    end
  end
end
