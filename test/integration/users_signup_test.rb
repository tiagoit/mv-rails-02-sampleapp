require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
  end

  test 'invalid signup information - empty name' do
    get signup_path
    assert_select 'form[action="/users"]'
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name: '', email: 'snow.john@got.tv', password: 'winterIsComing', password_confirmation: 'winterIsComing' } }
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors #user_name'
  end

  test 'invalid signup information - password_confirmation' do
    get signup_path
    assert_select 'form[action="/users"]'
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name: 'John Snow', email: 'snow.john@got.tv', password: 'winterIsComing', password_confirmation: 'cersei' } }
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors #user_password_confirmation'
  end

  test "valid signup information with account activation" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name:  "Example User",
                                       email: "user@example.com",
                                       password:              "password",
                                       password_confirmation: "password" } }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    assert_not user.activated?
    # Try to log in before activation.
    log_in_as(user)
    assert_not logged_in_for_test?
    # Invalid activation token
    get edit_account_activation_path("invalid token", email: user.email)
    assert_not logged_in_for_test?
    # Valid token, wrong email
    get edit_account_activation_path(user.activation_token, email: 'wrong')
    assert_not logged_in_for_test?
    # Valid activation token
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    assert logged_in_for_test?
  end
end
