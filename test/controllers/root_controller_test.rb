require 'test_helper'

describe RootController do

  setup do
    stub_user_session
  end

  context "the start page" do
    setup do
      # create some books
      FactoryBot.create_list(:book, 8)
    end

    should "be a successful request" do
      get :start

      assert response.success?
    end

    should "load eight books to display to the user" do
      get :start

      assert_equal 8, assigns(:books).count
      assert_instance_of Book, assigns(:books).first
    end

    should "load 3 recently added copies to display to the user" do
      get :start

      assert_equal 3, assigns(:recently_added_copies).count
      assert_instance_of Copy, assigns(:recently_added_copies).first
    end

    should "render the start template" do
      get :start

      assert_template "start"
    end
  end

end
