require "test_helper"

class Admin::InquiriesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_inquiries_index_url
    assert_response :success
  end

  test "should get show" do
    get admin_inquiries_show_url
    assert_response :success
  end

  test "should get update" do
    get admin_inquiries_update_url
    assert_response :success
  end
end
