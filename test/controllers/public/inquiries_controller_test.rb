require "test_helper"

class Public::InquiriesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get public_inquiries_new_url
    assert_response :success
  end

  test "should get create" do
    get public_inquiries_create_url
    assert_response :success
  end

  test "should get index" do
    get public_inquiries_index_url
    assert_response :success
  end

  test "should get update" do
    get public_inquiries_update_url
    assert_response :success
  end
end
