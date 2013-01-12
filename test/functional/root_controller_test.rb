require 'test_helper'

class RootControllerTest < ActionController::TestCase

  setup do
    login_as_stub_user
  end

  context "the start page" do
    setup do
      # create some books
      FactoryGirl.create_list(:book, 8)
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

    should "render the start template" do
      get :start

      assert_template "start"
    end
  end

end
