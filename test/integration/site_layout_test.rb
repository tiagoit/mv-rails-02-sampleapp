# frozen_string_literal: true

require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  test 'layout links' do
    @user = users(:michael)
    get root_path
    assert_template 'static_pages/home'

    # Home links
    assert_select 'a[href=?]', root_path, count: 2
    assert_select 'a[href=?]', help_path
    assert_select 'a[href=?]', about_path, count: 1
    assert_select 'a[href=?]', contact_path, count: 1
    assert_select 'a[href=?]', login_path, count: 1

    assert_select 'a[href=?]', users_path, count: 0
    assert_select 'a[href=?]', edit_user_path(@user), count: 0
    assert_select 'a[href=?]', logout_path, count: 0

    # only for logged in users
    log_in_as @user
    get root_path
    assert_template 'static_pages/home'
    assert_select 'a[href=?]', users_path, count: 1
    assert_select 'a[href=?]', edit_user_path(@user), count: 1
    assert_select 'a[href=?]', logout_path, count: 1

    get contact_path
    assert_select 'title', full_title('Contact')
    get signup_path
    assert_select 'title', full_title('Sign up')
  end
end
