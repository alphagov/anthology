require "integration_test_helper"

class UserControllerTest < ActionDispatch::IntegrationTest
  before do
    sign_in_user
    @user = User.find_by(email: "stub.user@example.org")
  end

  it "gets the user page" do
    get user_url(@user.id)

    assert_response :success
    assert_select "h1", "#{@user.name}’s Books"
    assert_select "p", "No previous loans"
  end

  it "shows the current loans" do
    loan = FactoryBot.create(:loan, user: @user)

    get user_url(@user.id)

    assert_select "h2", "Current loans"
    assert_select "section li", /#{loan.copy.book.title}/
  end

  it "shows the previous loans" do
    loan = FactoryBot.create(:loan, user: @user, state: "returned")

    get user_url(@user.id)

    assert_select "h2", "Previous loans"
    assert_select "section li", /#{loan.copy.book.title}/
  end
end
