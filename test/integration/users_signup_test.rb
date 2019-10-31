require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test "invalid signup information - empty name" do
    get signup_path
    assert_select 'form[action="/signup"]'
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name: '', email: 'snow.john@got.tv', password: 'winterIsComing', password_confirmation: 'winterIsComing' } }
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors #user_name'
  end

  test "invalid signup information - password_confirmation" do
    get signup_path
    assert_select 'form[action="/signup"]'
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name: 'John Snow', email: 'snow.john@got.tv', password: 'winterIsComing', password_confirmation: 'cersei' } }
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.field_with_errors #user_password_confirmation'
  end

  test "valid signup information" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name:  "Example User",
                                         email: "user@example.com",
                                         password:              "password",
                                         password_confirmation: "password" } }
    end
    follow_redirect!
    assert_template 'users/show'
    assert_equal 'User was successfully created.', flash[:success]
    assert is_logged_in?
  end
end
